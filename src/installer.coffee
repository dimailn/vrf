import dateInterceptor from './utils/date-interceptor'
import descriptors from './components/descriptors'
import indexBy from './utils/index-by'
import {installer} from 'vue-provide-observable'


export default (components) -> {
  install: (Vue, options) ->
    console.log("[vrf] v.#{process.env.VERSION}") if process.env.NODE_ENV == 'development'

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

    [
      'translate',
      'middlewares',
      'store',
      'autocompletes',
      'partials',
      'sources',
      'dateInterceptor',
      'transforms',
      'locale'
    ].forEach((optionName) -> Vue::VueResourceForm[optionName] = options[optionName] if options[optionName]?)
}
