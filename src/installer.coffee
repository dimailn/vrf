import dateInterceptor from './utils/date-interceptor'
import descriptors from './components/descriptors'
import indexBy from './utils/index-by'


# props is the hash with name => value

vpoWrapperUpdate = ->
  console.log 'vpo wrapper update'

  return if this.$options.$vpo

  Object.keys(@$options.provideObservable).forEach (pluginName) =>
    {nameMapper} = @$options.provideObservable[pluginName]

    for name in Object.keys(@["$vpoWrapper"][pluginName])
      @["$vpoWrapper"][pluginName][name] = @[nameMapper(name)]

VueProvideObservable = {
  provide: ->
    return unless @$options.provideObservable

    return if @$options.$vpo


    vue = Object.getPrototypeOf(@$root).constructor

    data = {}
    
    Object.keys(@$options.provideObservable).forEach (pluginName) =>
      {propsFactory} = @$options.provideObservable[pluginName]

      data[pluginName] = propsFactory()

    provide = {
      $vpo: { wrapper: new vue({data, $vpo: true}) }
    }


    @["$vpoWrapper"] = provide.$vpo.wrapper

    provide

  created: ->
    return unless @$options.provideObservable

    return if this.$options.$vpo
    

    # TO DO: optimize
    Object.keys(@$options.provideObservable).forEach (pluginName) =>
      {nameMapper} = @$options.provideObservable[pluginName]

      Object.keys(@["$vpoWrapper"][pluginName]).forEach (propertyName) =>
        @$watch(
          nameMapper(propertyName)
          =>
            # hotfix, replace with programmatically watch

            return if this.$options.$vpo

            vpoWrapperUpdate.bind(this)()
        )

    vpoWrapperUpdate.bind(this)()

  updated: ->
    return unless @$options.provideObservable

    return if this.$options.$vpo

    vpoWrapperUpdate.bind(this)()

}

VueProvideObservableInstaller = {
  install: (Vue, options) ->
    return if Vue::$vpo
    
    Vue.mixin(VueProvideObservable)
    Vue::$vpo = {}
}

export default (components) -> {
  install: (Vue, options) ->
    Vue.use(VueProvideObservableInstaller)

    installedComponentNames = []

    if options?.adapters? && options.adapters instanceof Array
      options.adapters.forEach((adapter) ->
        adapter.install?(Vue)
        for name, component of adapter.components
          unless component.vrfParent
            console.warn("[vrf] Component #{name} from #{adapter.name} has not vrfParent and will not initialized")
            continue

          descriptor = descriptors[component.vrfParent]

          unless descriptor
            console.warn("[vrf] Vrf parent #{component.vrfParent} is not found for component #{name} from #{adapter.name}")
            continue

          component.extends = descriptor

          component.computed ||= {}
          component.computed.$vrfParent = -> components[name]

          Vue.component(name, component)

          installedComponentNames.push name
      )

    installedComponentNames = indexBy(installedComponentNames)

    for name, component of components
      continue if installedComponentNames[name]
      Vue.component(name, component)

    Vue::VueResourceForm ||= {}

    Vue::VueResourceForm.dateInterceptor = dateInterceptor

    return unless options?

    if options.translate?
      Vue::VueResourceForm.translate = options.translate

    if options.middlewares?
      Vue::VueResourceForm.middlewares = options.middlewares
    if options.store?
      Vue::VueResourceForm.store = options.store

    if options.autocompletes?
      Vue::VueResourceForm.autocompletes = options.autocompletes

    if options.partials?
      Vue::VueResourceForm.partials = options.partials

    if options.sources?
      Vue::VueResourceForm.sources = options.sources

    if options.dateInterceptor?
      Vue::VueResourceForm.dateInterceptor = options.dateInterceptor

    if options.transforms?
      Vue::VueResourceForm.transforms = options.transforms

    if options.locale?
      Vue::VueResourceForm.locale = options.locale
}

