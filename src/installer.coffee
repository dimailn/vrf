import dateInterceptor from './utils/date-interceptor'
import descriptors from './components/descriptors'
import indexBy from './utils/index-by'
import {installer} from 'vue-provide-observable'


export default (components) -> {
  install: (Vue, options) ->
    Vue.use(installer)

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

