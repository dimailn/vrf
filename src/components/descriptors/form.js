var PathService, nameMapper, propsFactory;

import capitalizeFirst from '@/utils/capitalize-first';

import set from 'lodash.set';

import get from 'lodash.get';


import toPath from '@/utils/to-path';

import camelCase from '@/utils/camel-case';

import cloneDeep from 'lodash.clonedeep';

import {
  camelize
} from 'humps';

import VueProvideObservable from 'vue-provide-observable';

propsFactory = function() {
  return {
    resource: null,
    sources: null,
    $$resource: null,
    disabled: false,
    readonly: false,
    rfName: '',
    errors: {},
    submit: null,
    fetching: false,
    saving: false,
    vuex: false,
    pathService: void 0,
    rootResource: void 0,
    form: null,
    actionResults: {},
    actionPendings: {},
    lastSaveFailed: false,
    requireSource: null,
    translationName: null
  };
};

nameMapper = function(name) {
  switch (name) {
    case 'resource':
      return '$resource';
    case 'sources':
      return '$sources';
    case 'errors':
      return '$errors';
    case 'fetching':
      return '$fetching';
    case 'saving':
      return '$saving';
    case 'actionResults':
      return '$actionResults';
    case 'actionPendings':
      return '$actionPendings';
    case 'lastSaveFailed':
      return '$lastSaveFailed';
    case 'translationName':
      return '$translationName';
    default:
      return name;
  }
};

// import set from 'lodash.set'
PathService = class PathService {
  constructor() {
    this.root = {};
  }

  add(parentPath, name) {
    if (parentPath) {
      return set(this.root, parentPath, {
        [`${name}`]: {}
      });
    } else {
      return this.root[name] = {};
    }
  }

};

export default {
  name: 'rf-form',
  mixins: [VueProvideObservable('vrf', propsFactory, nameMapper)],
  provide: function() {
    return {
      vueResourceFormPath: this.path,
      vueResourceFormPathService: this.$pathService
    };
  },
  props: {
    /**
      * Main resource of form
      */
    resource: Object,
    /**
      * Sources for current form
      */
    sources: Object,
    /**
      * See sources
      * @deprecated
      * @ignore
      */
    resources: Object,
    /**
      * Make the whole form disabled
      */
    disabled: [Boolean, String],
    /**
      * Make the whole form readonly
      */
    readonly: [Boolean, String],
    /**
      * Name of the resource. This property is used for loading data and for translations
      */
    name: String,
    /**
      * Id of resource(for loading)
      */
    rfId: Number,
    /**
     * @ignore
     */
    rootName: String,
    /**
      * It overrides name property, if you need different translation scope
      */
    translationName: String,
    /**
      * Activate action automation using middlewares
      */
    auto: {
      type: Boolean,
      default: false
    },
    /**
      * It activate side effects in middleware, like redirection after new resource instance created
      */
    implicit: {
      type: Boolean,
      default: false
    },
    /**
      *  Disable fetching resource in auto mode when form is loaded
      */
    noFetch: {
      type: Boolean,
      default: false
    },
    /**
      *  Validation errors
      */
    errors: {
      type: Object,
      default: function() {
        return {};
      }
    },
    /**
      * Flag indicates form data is loading
      */
    fetching: Boolean,
    /**
      * Flag indicates form data is saving
      */
    saving: Boolean,
    /**
      * If it's true, resource store is stored in vuex(mutation installation required)
      */
    vuex: {
      type: Boolean,
      default: false
    },
    /**
      * If it's true, resources have no id and are one of a kind
      */
    single: {
      type: Boolean,
      default: false
    },
    /**
      *Middleware identifier
    */
    api: {
      type: String
    },
    /**
      * Namespace for API
    */
    namespace: {
      type: String
    },
    /**
      * Sync prop for getting action results
      */
    actionResults: {
      type: Object
    },
    /**
      * Sync prop for getting action pendings
      */
    actionPendings: {
      type: Object
    },
    // Internal service settings used for nested forms
    /**
     * @ignore
     */
    path: Array,
    /**
     * @ignore
     */
    pathService: Object,
    /**
     * @ignore
     */
    rootResource: Object
  },
  data: function() {
    return {
      innerResource: null,
      innerSources: null,
      innerErrors: null,
      innerFetching: false,
      innerSaving: false,
      innerActionResults: {},
      innerActionPendings: {},
      innerLastSaveFailed: false,
      requiredSources: {}
    };
  },
  watch: {
    rfId: function() {
      return this.forceReload({
        boot: true
      });
    },
    resource: function(old, current) {
      if (old === current) {
        return;
      }
      return this.innerResource = null;
    }
  },
  mounted: function() {
    return this.forceReload({
      boot: true
    });
  },
  computed: {
    tailPath: function() {
      var lastElement;
      if (!this.path) {
        return;
      }
      lastElement = this.path[this.path.length - 1];
      if (typeof lastElement === 'number') {
        return [this.path[this.path.length - 2], lastElement];
      } else {
        return [lastElement];
      }
    },
    form: function() {
      return this;
    },
    rfName: function() {
      return this.name;
    },
    $translationName: function() {
      return this.translationName || this.name;
    },
    $$resource: function() {
      return this.resource;
    },
    $resource: function() {
      if (this.vuex) {
        return this.$store.state[camelCase(this.name)];
      }
      return this.innerResource || this.resource;
    },
    $sources: function() {
      return this.innerSources || this.sources || this.$resourcesDeprecated || {};
    },
    $resourcesDeprecated: function() {
      if (!this.resources) {
        return;
      }
      console.warn('[vrf] Prop "resources" was deprecated and will be removed in next version. Please, use "sources" instead.');
      return this.resources;
    },
    $errors: function() {
      return this.innerErrors || this.errors;
    },
    $fetching: function() {
      return this.innerFetching || this.fetching;
    },
    $saving: function() {
      return this.innerSaving || this.saving;
    },
    $actionResults: function() {
      return this.innerActionResults || this.actionResults;
    },
    $actionPendings: function() {
      return this.innerActionPendings || this.actionPendings;
    },
    $lastSaveFailed: function() {
      return this.innerLastSaveFailed;
    },
    middleware: function() {
      var middleware;
      middleware = (this.VueResourceForm.middlewares || []).find((middleware) => {
        return middleware.accepts({
          name: this.name,
          api: this.api,
          namespace: this.namespace
        });
      });
      if (!middleware) {
        throw `Can't find middleware for ${this.name} resource`;
      }
      return new middleware(this.rfName, this);
    },
    $pathService: function() {
      return window.pathService = this.pathService || new PathService;
    },
    isReloadPossible: function() {
      return this.auto || (this.path != null);
    },
    isNested: function() {
      return !!this.path;
    }
  },
  methods: {
    forceReload: function(options = {
        boot: false
      }) {
      if (!this.auto) {
        return;
      }
      if (!this.name) {
        throw "You must provide name for auto-forms.";
      }
      if (!this.VueResourceForm.middlewares) {
        throw "You must provide middlewares for auto-forms.";
      }
      if (this.noFetch && options.boot) {
        this.reloadSources();
        return;
      }
      this.$emit('before-load');
      this.setSyncProp('fetching', true);
      return Promise.all([this.reloadSources(), this.reloadResource()]).then(() => {
        return this.$emit('after-load-success');
      }).finally(() => {
        this.setSyncProp('errors', {});
        return this.setSyncProp('fetching', false);
      });
    },
    reloadSources: function() {
      if (!this.isReloadPossible) {
        return console.warn("Reload methods is applicable only to auto-forms");
      }
      if (this.isNested) {
        return this.$emit('reload-sources');
      }
      if (Object.keys(this.requiredSources).length === 0) {
        return;
      }
      return this.middleware.loadSources(Object.keys(this.requiredSources)).then((sources) => {
        if (Object.keys(this.$sources).length > 0) {
          sources = {...this.$sources, ...sources};
        }
        return this.setSyncProp('sources', sources);
      });
    },
    reloadResource: function(modifier) {
      var nestedPath;
      if (!this.isReloadPossible) {
        return console.warn("Reload methods is applicable only to auto-forms");
      }
      if (this.isNested) {
        if (this.tailPath) {
          nestedPath = toPath(this.tailPath);
          modifier = modifier instanceof Array ? modifier.map(function(m) {
            return `${nestedPath}.${m}`;
          }) : [nestedPath];
        }
        return this.$emit('reload-resource', modifier);
      }
      return this.reloadRootResource(modifier);
    },
    reloadRootResource: function(modifier) {
      if (this.isNested) {
        return this.$emit('reload-root-resource', modifier);
      }
      return this.middleware.load().then((resource) => {
        if (this.vuex) {
          this.$store.commit('vue-resource-form:set', {
            resourceName: this.name,
            payload: resource
          });
        }
        if (!modifier || !this.innerResource) {
          this.innerResource = resource;
        } else {
          if (!(modifier instanceof Array)) {
            throw 'Modifier must be an array';
          }

          modifier.forEach((path) => set(this.innerResource, path, get(resource, path)))
        }
        if (this.innerResource != null) {
          return this.$emit('update:resource', this.innerResource);
        }
      });
    },
    setSyncProp: function(name, value) {
      this[`inner${capitalizeFirst(camelize(name))}`] = value;
      this.$emit(`update:${name}`, value);
      if (name === 'sources') { // for deprecated prop sources sync
        return this.$emit("update:resources", value);
      }
    },
    submit: function() {
      // Даем отработать onChange
      return this.$nextTick(() => {
        this.$emit('before-submit', {
          resource: this.$resource
        });
        this.$emit('submit', {
          resource: this.$resource
        });
        if (!this.auto) {
          return;
        }
        this.setSyncProp('saving', true);
        return this.middleware.save(this.$resource).then(([ok, errors]) => {
          this.innerLastSaveFailed = !ok;
          this.setSyncProp('saving', false);
          this.setSyncProp('errors', ok ? {} : errors);
          this.$emit('after-submit');
          return this.$emit(ok ? 'after-submit-success' : 'after-submit-failure');
        }).catch(console.error);
      });
    },
    preserialize: function() {
      var children, name, ref, resource;
      resource = cloneDeep(this.$resource);
      ref = this.form.$pathService.root;
      for (name in ref) {
        children = ref[name];
        resource[name + 'Attributes'] = resource[name];
        delete resource[name];
      }
      return resource;
    },
    deserialize: function(json) {},
    setResource: function(resource) {
      return this.setSyncProp('resource', resource);
    },
    executeAction: function(name, {params, data, method = 'post', url} = {}) {
      var result;
      this.setActionPending(name, true);
      result = void 0;
      return this.middleware.executeAction(name, {params, data, method, url}).then(({status, data}) => {
        return result = {status, data};
      }).catch((e = {status, data}) => {
        if (!status) {
          throw e;
        }
        return result = {status, data};
      }).finally(() => {
        return this.setActionResult(name, result);
      });
    },
    setActionResult: function(name, result) {
      this.setSyncProp('actionResults', {
        ...this.$actionResults,
        [name]: result
      });
      return this.setActionPending(name, false);
    },
    setActionPending: function(name, inProgress) {
      return this.setSyncProp('actionPendings', {
        ...this.$actionPendings,
        [name]: inProgress
      });
    },
    requireSource: function(name) {
      if(this.isNested){
        this.$emit('require-source', name)
        return
      }
      if (this.$sources && this.$sources[name]) {
        return this.$sources[name];
      }
      if (!this.requiredSources[name] && this.innerResource) {
        this.middleware.loadSource(name).then((sourceCollection) => {
          return this.form.addToSources(name, sourceCollection);
        });
      }
      return this.requiredSources[name] = true;
    },
    addToSources: function(name, value) {
      if (!this.innerSources) {
        return this.setSyncProp('sources', {
          [`${name}`]: value
        });
      }
      return this.$set(this.innerSources, name, value);
    }
  }
};
