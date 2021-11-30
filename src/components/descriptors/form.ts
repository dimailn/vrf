// import Vue, {PropType} from 'vue'

import capitalizeFirst from '@/utils/capitalize-first';

import set from '@/utils/set';

import get from 'lodash.get';


import toPath from '@/utils/to-path';

import camelCase from '@/utils/camel-case';

import {decamelize} from 'humps'

import pluralize from 'pluralize'

import cloneDeep from 'lodash.clonedeep';

import {
  camelize
} from 'humps';

import VueProvideObservable from 'vue-provide-observable';

import {Effect, EffectExecutor, InstantiatedEffect, EffectListenerNames} from '../../types/effect'
import VrfEvent from '../../types/vrf-event'
import PathService from '../../types/path-service'


const propsFactory = function() {
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

const nameMapper = function(name) {
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
      * Activate action automation using api effects
      */
    auto: {
      type: Boolean,
      default: false
    },
    /**
     * Non-API effects activation(like redirection after new resource instance created). You may activate/disable all effects by passing true/false or apply current effects by enumerating names within array.
     */
    effects: {
      type: [
        Boolean,
        Array
      ] // as PropType<boolean | Array<string>>
    },
    /**
      * Boolean alias to effects
      * @deprecated
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
      * API effect identifier or custom effect implementation
    */
    api: {
      type: [
        String,
        Object
      ] // as PropType<string | EffectExecutor>
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
  mounted() {
    const listenerNames = [
      'onLoad',
      'onSave',
      'onExecuteAction',
      'onLoadSource',
      'onLoadSources',
      'onCreate',
      'onCreated',
      'onUpdate'
    ]

    this.instantiatedEffects = this.$effects.map(({effect, name, api}: Effect) => {
      const instantiatedEffect : InstantiatedEffect = {
        listeners: listenerNames.reduce((listeners, eventName) => {
          listeners[eventName] = null

          return listeners
        }, {} as Record<EffectListenerNames, (...args: any) => any>),
        customEventListeners: {},
        api
      }

      const resourceName  = () => camelCase(this.name.split("::")[0])
      const urlResourceName = () => decamelize(this.name.split("::")[0])
      const urlResourceCollectionName = () => pluralize(urlResourceName())

      effect({
        ...listenerNames.reduce((setters, eventName) => {
          setters[eventName] = (listener) => {
            instantiatedEffect.listeners[eventName] = listener
          }
  
          return setters
        }, {} as Record<EffectListenerNames, (...args: any) => any>),
        on(eventName, listener){
          instantiatedEffect.customEventListeners[eventName] ||= []
          instantiatedEffect.customEventListeners[eventName].push(listener)
        },
        emit(eventName, payload){
          const event = new VrfEvent(eventName, payload)

          this.instantiatedEffects.find((instantiatedEffect) => instantiatedEffect.customEventListeners.find((listener) => {
            listener(event)

            return event.isStopped()
          })
          )
        },
        resourceName,
        urlResourceName,
        urlResourceCollectionName,
        form: this
      })

      return instantiatedEffect
    })

    this.forceReload({
      boot: true
    })

    if(this.vuex) {
      this.$emit('update:resource', this.$resource)
    }
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
    $effects() : Array<Effect> {
      const effects : Array<Effect> = [...(this.VueResourceForm.effects || [])]
        .filter((effect) => (this.auto && effect.api) || this.effects === true || (this.effects instanceof Array && this.effects.includes(effect.name)) || this.implicit === true)

      if(this.auto){
        effects.push({
          name: 'reload-on-create',
          effect: ({onCreated}) => {
            onCreated((event) => {
              this.executeEffectAction('onLoad', true, [event.payload.id])
            })
          }
        })
      }

      if(typeof this.api === 'function') {
        effects.unshift(this.api)
      } else if(typeof this.api === 'string') {
        const prioritizedEffectIndex = effects.findIndex((effect) => effect.name === this.api)
        if(!prioritizedEffectIndex) {
          throw `[vrf] Effect with name ${this.api} isn't registered`
        }
        const prioritizedEffect = effects[prioritizedEffectIndex]
        effects.splice(prioritizedEffectIndex, 1)
        effects.unshift(prioritizedEffect)
      }

      return effects
    },
    $pathService: function() {
      return this.pathService || new PathService;
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
      if (!this.VueResourceForm.effects) {
        throw "You must provide effects for auto-forms.";
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

      const sourceNames = Object.keys(this.requiredSources)

      return this.executeEffectAction('onLoadSources', true, [sourceNames]).then((sources) => {
        if (Object.keys(this.$sources).length > 0) {
          sources = {...this.$sources, ...sources};
        }
        return this.setSyncProp('sources', sources);
      })
    },
    reloadResource: function(modifier) {
      if (!this.isReloadPossible) {
        return console.warn("Reload methods is applicable only to auto-forms");
      }
      if (this.isNested) {
        if (this.tailPath) {
          const nestedPath = toPath(this.tailPath);
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

      if(this.isNew()){
        return
      }

      return this.executeEffectAction('onLoad', true, [this.resourceId()]).then((resource) => {
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
    resourceId(){
      if(this.rfId !== undefined) {
        return this.rfId
      }

      if(this.$resource?.id){
        return this.$resource.id
      }

      const idFromRoute = this.VueResourceForm.idFromRoute || ((form) => form.$route?.params?.id)

      return idFromRoute(this)
    },
    isNew(){
      return this.single ? false : !this.resourceId()
    },
    submit: function() {
      // let onChange inputs change the model
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

        let eventResult = this.executeEffectActionOptional('onSave', true, [this.$resource])

        if(!(eventResult instanceof Promise)){
          eventResult = this.isNew() ?
            this.executeEffectAction('onCreate', true, [this.$resource])
            .then(([ok, id]) => {
              if(ok && !id){
                throw '[vrf] onCreate handler must return id of created resource when it succeed'
              }

              this.executeEffectAction('onCreated', false, [
                new VrfEvent('onCreated', {id})
              ])

              return [ok, id]
            })
            :
            this.executeEffectAction('onUpdate', true, [this.$resource])
        }
        
        return eventResult.then(([ok, errors]) => {
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
      let result = null
      this.setActionPending(name, true);
  
      return this.executeEffectAction('onExecuteAction', true, [name, {params, data, method, url}]).then(({status, data}) => {
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
    executeEffectAction(eventName: EffectListenerNames, api: boolean, args: Array<any> = []): Promise<any> | void {
      const effectPerformed = this.executeEffectActionOptional(eventName, api, args)

      if(!(effectPerformed instanceof Promise) && api){
        throw `[vrf] API call ${eventName} on resource ${this.name} was executed, but there is no effect to handle it. Make sure that you have an API effect which handles this event and returns Promise.`
      }

      return effectPerformed
    },
    executeEffectActionOptional(eventName: EffectListenerNames, api: boolean, args: Array<any> = []): Promise<any> | void {
      const effectPerformed = this.instantiatedEffects.reduce((result: Promise<any> | void, effect: InstantiatedEffect) =>  {
        const listener : (...args: any) => any = effect.listeners[eventName]

        const {api} = effect
        
        if(!listener || args[0] instanceof VrfEvent && args[0].isStopped()) {
          return result
        }

        if(!api) {
          listener(...args)
        } else if(result === null) {
          const currentListenerResult = listener(...args)

          if(currentListenerResult instanceof Promise)
            return currentListenerResult  
        }

        return result
      }, null)

      return effectPerformed
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
        this.executeEffectAction('onLoadSource', true, [name]).then((sourceCollection) => {
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
}
