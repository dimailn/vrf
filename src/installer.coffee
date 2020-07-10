import dateInterceptor from './utils/date-interceptor'


export default (components) -> {
  install: (Vue, options) ->
    for name, component of components
      Vue.component(name, component)

    Vue::VueResourceForm ||= {}

    Vue::VueResourceForm.dateInterceptor = dateInterceptor

    return unless options?

    if options.translate?
      Vue::VueResourceForm.translate = options.translate

    if options.NetworkLayer?
      Vue::VueResourceForm.NetworkLayer = options.NetworkLayer
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
}

