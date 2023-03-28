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

import {Effect, EffectExecutor, InstantiatedEffect, EffectListenerNames, Event, Message} from '../../types/effect'
import VrfEvent from '../../types/vrf-event'
import PathService from '../../types/path-service'
import Templates from '@/mixins/templates'

export const propsFactory = function() {
  return {
    resource: null,
    sources: null,
    formDisabled: false,
    formReadonly: false,
    rfName: '',
    errors: {},
    submit: null,
    fetching: false,
    saving: false,
    vuex: false,
    rootResource: undefined,
    form: null,
    actionResults: {},
    actionPendings: {},
    lastSaveFailed: false,
    requireSource: null,
    translationName: null,
    scope: null
  };
};

export const nameMapper = function(name) {
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
    case 'formDisabled':
      return 'disabled';
    case 'formReadonly':
      return 'readonly';
    case 'rootResource':
      return '$rootResource';
    case 'scope':
      return '$scope';
    default:
      return name;
  }
};


export default {
  name: 'rf-form',
  mixins: [
    VueProvideObservable('vrf', propsFactory, nameMapper),
    Templates
  ],
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
    value: Object,
    /**
      * Alias to value
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
    disabled: Boolean,
    /**
      * Make the whole form readonly
      */
    readonly: Boolean,
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
      * Activate action automation using api effects.
      * You may specify the name of api effect to prioritize current effect.
      * Also it's possible to pass current effect implementation ad hoc.
      */
    auto: {
      type: [
        Boolean,
        String,
        Function
      ], // as PropType<boolean | string | EffectExecutor>,
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
      *  Disable fetching resource in auto mode when form is loaded
      */
    noFetch: {
      type: Boolean,
      default: false
    },
    /**
     * Enable fetching for new resources(without an id)
     */
    fetchAlways: {
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
     * Flag indicates last save failed
     */
    lastSaveFailed: Boolean,

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
    /**
     * Postfix for nested attributes for serialization
     */
    nestedPostfix: {
      type: String,
      default: 'Attributes'
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
    rootResource: Object,
    /**
     * @ignore
     */
    rootElement: String
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
      requiredSources: {},
      sourcesLoaded: false
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
    },
    $effects(){
      console.log('$effects changed, mount effects...')

      this.executeEffectEventOptional('onUnmounted', false, [])

      this.mountEffects()
    }
  },
  beforeDestroy(){
    this.executeEffectEventOptional('onUnmounted', false, [])
  },
  render(h){
    if(this.rootElement){
      return h(this.rootElement, {}, this.$slots.default)
    }

    const genForm = (children?: any) => h(
      'form', {
        on: { submit: (e) => e.preventDefault() }
      },
      children
    )

    if(this.isNested){
      if(this.$slots.default && this.$slots.default.length > 1) {
        genForm(this.$slots.default)
      } else {
        return this.$slots.default
      }
    }

    if(!this.$resource){
      return genForm()
    }

    const show = !this.$fetching
    const options =           {
      directives: [
        {
          name: 'show',
          value: show
        }
      ],
      attrs: {
        class: 'vrf__root-wrapper'
      }
    }

    const children = []

    if((this.auto && this.$fetching || !this.$resource) && this.$loader){
      children.push(
        h(
          this.$loader,
          {}
        )
      )
    }

    if(this.$scopedSlots.default && this.$resource){
      children.push(
        h(
          'div',
          options,
          this.$scopedSlots.default({$resource: this.$resource})
        )
      )
    } else {
      children.push(
        h(
          'div',
          options,
          this.$slots.default
        )
      )
    }

    return genForm(children)
  },
  mounted() {
    if(this.value && this.resource) {
      console.error('[vrf] The props value and resource are specified both, you need to use only one, value is preferrable.')
    }

    this.mountEffects()

    if(this.auto && !this.resourceId() && !this.$resource){
      this.innerResource = {}
    }

    this.forceReload({
      boot: true
    })

    if(this.vuex) {
      this.$emit('update:resource', this.$resource)
    }
  },
  computed: {
    tailPath() {
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
    form() {
      return this;
    },
    rfName() {
      return this.name;
    },
    $name() {
      if (!this.name) {
        return
      }

      return this.name.split("#")[0]
    },
    $translationName() {
      return this.translationName || this.$name;
    },
    $$resource() {
      return this.value || this.resource;
    },
    $resource() {
      if (this.vuex) {
        return this.$store.state[camelCase(this.$name)];
      }
      return this.innerResource || this.$$resource;
    },
    $sources() {
      return this.innerSources || this.sources || this.$resourcesDeprecated || {};
    },
    $resourcesDeprecated() {
      if (!this.resources) {
        return;
      }
      console.warn('[vrf] Prop "resources" was deprecated and will be removed in next version. Please, use "sources" instead.');
      return this.resources;
    },
    $errors() {
      return this.innerErrors || this.errors;
    },
    $fetching() {
      return this.innerFetching || this.fetching;
    },
    $saving() {
      return this.innerSaving || this.saving;
    },
    $actionResults() {
      return this.innerActionResults || this.actionResults;
    },
    $actionPendings() {
      return this.innerActionPendings || this.actionPendings;
    },
    $lastSaveFailed() {
      return this.innerLastSaveFailed || this.lastSaveFailed;
    },
    $effects() : Array<Effect> {
      const effects : Array<Effect> = [...(this.VueResourceForm.effects || [])]
        .filter(
          (effect) =>
            (this.auto && effect.api) ||
            this.effects === true ||
            (this.effects instanceof Array && this.effects.includes(effect.name))
        )

      if(this.effects instanceof Array) {
        this.effects
          .filter(effect => typeof effect === 'object' && effect.effect)
          .forEach(effect => effects.push(effect))
      }

      if(this.auto){
        effects.push({
          name: 'reload-on-create',
          effect: ({onCreated}) => {
            onCreated((event) => {
              return this.executeOnLoad(event.payload.id)
            })
          }
        })
      }

      effects.push({
        name: 'message-trap',
        effect: ({onShowMessage}) => {
          onShowMessage(({payload: {text}}) => {
            console.warn(`[vrf] Message "${text}" was emitted for form ${this.name}, but there is no effect to handle it. Probably, you should add effect to show messages.`)
          })
        }
      })

      if(typeof this.auto === 'function') {
        effects.unshift({effect: this.auto, api: true})
      } else if(typeof this.auto === 'string' && this.auto !== '') {
        const prioritizedEffectIndex = effects.findIndex((effect) => effect.name === this.auto)
        if(prioritizedEffectIndex === -1) {
          throw `[vrf] Effect with name ${this.auto} isn't registered`
        }
        const prioritizedEffect = effects[prioritizedEffectIndex]
        effects.splice(prioritizedEffectIndex, 1)
        effects.unshift(prioritizedEffect)
      }

      return effects
    },
    $pathService() {
      return this.pathService || new PathService;
    },
    isReloadPossible() {
      return this.auto || (this.path != null);
    },
    isNested() {
      return !!this.path;
    },
    $loader() {
      if (this.$templates.loader) {
        return this.$templates.loader
      }

      if (this.VueResourceForm.loader) {
        console.warn('[vrf] Using Vue.prototype.VueResourceForm.loader is deprecated and will be removed, use templates adapter option instead.')

        return this.VueResourceForm.loader
      }
    },
    $rootResource() {
      return this.rootResource || this.$resource
    },
    $scope() {
      return {
        emit() {

        }
      }
    }
  },
  methods: {
    forceReload(options = {
        boot: false
      }) {
      if (!this.auto) {
        return;
      }
      if (!this.name) {
        throw "You must provide name for auto-forms.";
      }
      if (!this.VueResourceForm.effects && typeof this.auto !== 'function') {
        throw "You must provide effects for auto-forms.";
      }
      if (this.noFetch && options.boot) {
        this.reloadSources();
        return;
      }
      this.$emit('before-load')
      this.setSyncProp('fetching', true)

      Promise.all([this.reloadResource()])
        .then(() => this.$nextTick())
        .then(this.reloadSources)
        .then(() => {
          this.$emit('after-load-success')
          this.executeEffectEventOptional('onLoaded', false, [])
        })
        .finally(() => {
          this.setSyncProp('errors', {});
          this.setSyncProp('fetching', false);
        })
    },
    reloadSources() {
      if (!this.isReloadPossible) {
        return console.warn("Reload methods is applicable only to auto-forms");
      }
      if (this.isNested) {
        return this.$emit('reload-sources');
      }
      if (Object.keys(this.requiredSources).length === 0) {
        !this.$sources && this.setSyncProp('sources', {})

        this.sourcesLoaded = true
        return
      }

      const sourceNames = Object.keys(this.requiredSources)

      return this.executeEffectEvent('onLoadSources', true, [sourceNames]).then((sources) => {
        sources = Object.keys(sources).reduce((convertedSources, key) => {
          const collection = sources[key]

          convertedSources[key] = collection.map(this.executeOnAfterLoad)

          return convertedSources
        }, sources)

        if (Object.keys(this.$sources).length > 0) {
          sources = {...this.$sources, ...sources};
        }
        this.setSyncProp('sources', sources)
        this.sourcesLoaded = true
      })
    },
    reloadResource(modifier) {
      if (!this.isReloadPossible) {
        return console.warn("Reload methods is applicable only to auto-forms");
      }
      if (this.isNested) {
        if (this.tailPath) {
          const nestedPath = toPath(this.tailPath);
          modifier = modifier instanceof Array ? modifier.map(m => `${nestedPath}.${m}`) : [nestedPath]
        }
        return this.$emit('reload-resource', modifier);
      }
      return this.reloadRootResource(modifier)
    },
    reloadRootResource(modifier) {
      if (this.isNested) {
        return this.$emit('reload-root-resource', modifier);
      }

      if(this.isNew() && !this.fetchAlways){
        return
      }

      return this.executeOnLoad(this.resourceId(), modifier)
    },
    clearErrors() {
      this.setSyncProp('errors', {});
    },
    executeOnLoad(resourceId, modifier){
      return this.executeEffectEvent('onLoad', true, [resourceId])
      .then((resource) => {
        resource = this.executeOnAfterLoad(resource)


        if (this.vuex) {
          this.$store.commit('vue-resource-form:set', {
            resourceName: this.$name,
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
    setSyncProp(name, value) {
      this[`inner${capitalizeFirst(camelize(name))}`] = value;
      this.$emit(`update:${name}`, value);
      if (name === 'sources') { // for deprecated prop sources sync
        return this.$emit("update:resources", value)
      }

      if(name === 'resource') {
        this.$emit('input', value)
      }
    },
    resourceId(){
      if(this.rfId !== undefined) {
        return this.rfId
      }

      const {idFromRoute} = this.VueResourceForm

      const id = idFromRoute(this)


      if(process.env.NODE_ENV !== 'production' && id === undefined && this.auto){
        console.warn(`[vrf] You haven\'t specified rf-id prop for form ${this.$name}, in this case vrf use idFromRouter helper. However, resource id returned from idFromRouter is undefined, but it should be null for a new resource. It may mean that idFromRouter doesn\'t work properly, or you forgot to pass id of the resource.`)
      }

      return id
    },
    isNew(){
      return this.single ? false : !this.resourceId()
    },
    submit(resource = cloneDeep(this.$resource), root) {
      if (resource.initUIEvent && typeof resource.initUIEvent === 'function') {
        resource = cloneDeep(this.$resource)
      }
      // let onChange inputs change the model
      return this.$nextTick(() => {
        this.$emit('before-submit', {
          resource
        });
        this.$emit('submit', {
          resource
        });
        if (!this.auto) {
          return;
        }
        this.setSyncProp('saving', true);

        resource = this.executeEffectEventFold('onBeforeSave', 'resource', this.preserialize(resource, root))

        if(!resource || typeof resource !== 'object') {
          throw `[vrf] onBeforeSave handlers should return an object, but result is ${resource}`
        }

        let eventResult = this.executeEffectEventOptional('onSave', true, [resource])

        if(!(eventResult instanceof Promise)){
          eventResult = this.isNew() ?
            this.executeEffectEvent('onCreate', true, [resource])
            .then(([ok, id]) => {
              if(ok && !id){
                throw '[vrf] onCreate handler must return id of created resource when it succeed'
              }

              if(ok) {
                this.setSyncProp('rfId', id)
                return Promise.all(this.executeEffectEventMap('onCreated', {id})).then(() => [ok, id])
              }

              return [ok, id]
            })
            :
            this.executeEffectEvent('onUpdate', true, [resource])
        }

        return eventResult.then((result) => {
          if (!(result instanceof Array) || result.length !== 2 || typeof result[0] !== 'boolean') {

            console.error('[vrf] Handlers of onSave/onCreate/onUpdate events must return an array with boolean status as first element and id/resource/errors/ as second.')
            return
          }

          const [ok, dataOrErrors] = result

          this.innerLastSaveFailed = !ok
          this.setSyncProp('saving', false)
          this.setSyncProp('errors', ok ? {} : dataOrErrors)
          this.$emit('after-submit')
          if(ok && typeof dataOrErrors === 'object'){
            this.setSyncProp('resource', dataOrErrors)
          }
          if(!ok){
            this.executeEffectEventOptional('onFailure', false, [new VrfEvent('onFailure', {errors: dataOrErrors})])
          } else {
            this.executeEffectEventOptional('onSuccess', false, [])
          }
          return this.$emit(ok ? 'after-submit-success' : 'after-submit-failure')
        }).catch(console.error)
      })
    },
    preserialize(resource, root) {
      resource ||= cloneDeep(this.$resource)
      root ||= this.form.$pathService.root

      for (let name in root) {
        const value = resource[name]

        delete resource[name]

        resource[name + this.nestedPostfix] = value

        if(Object.keys(root[name]).length > 0) {
          this.preserialize(resource[name], root[name])
        }
      }

      return resource
    },
    deserialize(json) {},
    setResource(resource) {
      return this.setSyncProp('resource', resource);
    },
    executeAction(name, {params, data, method = 'post', url} = {}) {
      let result = null
      this.setActionPending(name, true);

      return this.executeEffectEvent('onExecuteAction', true, [name, {params, data, method, url}])
        .then(({status, data, statusHandle}) => {
          return result = {status, data, statusHandle}
        }).catch((e = {status, data, statusHandle}) => {
          if (!status) {
            throw e;
          }
          return result = {status, data, statusHandle}
        }).finally(() => {
          return this.setActionResult(name, result);
        })
    },
    executeEffectEvent(eventName: EffectListenerNames, api: boolean, args: Array<any> = []): Promise<any> | void {
      const effectResult = this.executeEffectEventOptional(eventName, api, args)

      if(effectResult === null && api){
        throw `[vrf] API call ${eventName} on resource ${this.$name} was executed, but there is no effect to handle it. Make sure that you have an API effect which handles this event and returns Promise.`
      }

      if(!(effectResult instanceof Promise || effectResult === undefined) && api){
        throw `[vrf] API call ${eventName} on resource ${this.$name} was executed, but effect's handler returned unexpected value. It should be a Promise or undefined, but ${effectResult} was returned.`
      }

      return effectResult
    },
    executeEffectEventOptional(eventName: EffectListenerNames, api: boolean, args: Array<any> = []): Promise<any> | void {
      return this.executeEffectEventAbstract((result, effect, stop) => {
        const {api} = effect
        const listener : (...args: any) => any = effect.listeners[eventName]


        if(args[0] instanceof VrfEvent && args[0].isStopped()){
          stop()

          return result
        }

        if(!listener) {
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
      })
    },
    executeEffectEventMap(eventName: EffectListenerNames, payload){
      return this.executeEffectEventAbstract((result, effect, stop) => {
        const listener : (...args: any) => any = effect.listeners[eventName]

        if(!listener) {
          return result
        }


        const event = new VrfEvent(eventName, payload)

        const currentResult = listener(event)

        result.push(currentResult)

        if(event.isStopped()){
          stop()
        }

        return result

      }, [])
    },
    executeEffectEventFold(eventName: EffectListenerNames, payloadKey: string, payload){
      return this.executeEffectEventAbstract((result, effect, stop) => {
        const listener : (...args: any) => any = effect.listeners[eventName]

        if(!listener) {
          return result
        }

        const event = new VrfEvent(eventName, {[payloadKey]: result})
        result = listener(event)

        if(event.isStopped()){
          stop()
        }

        return result
      }, payload)
    },
    executeEffectEventAbstract(
      lambda: (
        result: Promise<any> | any,
        effect: InstantiatedEffect,
        stop: () => void
      ) => any,
      initialValue = null
    ){
      let result = initialValue
      let stopped = false

      const stop = () => stopped = true

      for(let effect of this.instantiatedEffects){
        result = lambda(result, effect, stop)

        if(stopped){
          break
        }
      }

      return result
    },
    executeOnAfterLoad(resource: object){
      resource = this.executeEffectEventFold('onAfterLoad', 'resource', resource)

      if(!(resource && typeof resource === 'object')){
        throw `[vrf] onAfterLoad handlers should return an object, but result is ${resource}`
      }

      return resource
    },
    setActionResult(name, result) {
      this.setSyncProp('actionResults', {
        ...this.$actionResults,
        [name]: result
      });
      return this.setActionPending(name, false);
    },
    setActionPending(name, inProgress) {
      return this.setSyncProp('actionPendings', {
        ...this.$actionPendings,
        [name]: inProgress
      });
    },
    requireSource(name) {
      if(this.isNested){
        this.$emit('require-source', name)
        return
      }
      if (this.$sources && this.$sources[name]) {
        return this.$sources[name];
      }

      this.addToSources(name, [])

      if (!this.requiredSources[name] && this.sourcesLoaded) {
        this.executeEffectEvent('onLoadSource', true, [name]).then((sourceCollection) => {
          return this.addToSources(name, sourceCollection);
        });
      }
      return this.requiredSources[name] = true;
    },
    addToSources(name, value) {
      if (!this.innerSources) {
        return this.setSyncProp('sources', {
          [`${name}`]: value
        });
      }
      return this.$set(this.innerSources, name, value);
    },
    mountEffects(){
      const listenerNames = [
        'onLoad',
        'onSave',
        'onExecuteAction',
        'onLoadSource',
        'onLoadSources',
        'onCreate',
        'onCreated',
        'onUpdate',
        'onMounted',
        'onUnmounted',
        'onAfterLoad',
        'onBeforeSave',
        'onFailure',
        'onSuccess',
        'onLoaded'
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

        const resourceName  = () => camelCase(this.$name.split("::")[0])
        const urlResourceName = () => decamelize(this.$name.split("::")[0])
        const urlResourceCollectionName = () => pluralize(urlResourceName())

        const on = (eventName, listener) => {
          instantiatedEffect.customEventListeners[eventName] ||= []
          instantiatedEffect.customEventListeners[eventName].push(listener)
        }

        const emit = (eventName, payload) => {
          const event = new VrfEvent(eventName, payload)

          this.instantiatedEffects.find((instantiatedEffect) => instantiatedEffect.customEventListeners[eventName]?.find((listener) => {
            listener(event)

            return event.isStopped()
          })
          )
        }

        const showMessage = (message: Message) => emit('message', message)
        const onShowMessage = (listener: (listener: Event<Message>) => void) => on('message', listener)

        effect({
          ...listenerNames.reduce((setters, eventName) => {
            setters[eventName] = (listener) => {
              instantiatedEffect.listeners[eventName] = listener
            }

            return setters
          }, {} as Record<EffectListenerNames, (...args: any) => any>),

          strings: {
            resourceName,
            urlResourceName,
            urlResourceCollectionName,
          },
          showMessage,
          onShowMessage,
          form: this
        })

        return instantiatedEffect
      })

      this.executeEffectEventOptional('onMounted', false, [])
    }
  }
}
