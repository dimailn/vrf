export default (components) -> {
  install: (Vue, options) ->
    for name, component of components
      Vue.component(name, component)

    Vue::VueResourceForm ||= {}

    return unless options?

    if options.NetworkLayer?
      Vue::VueResourceForm.NetworkLayer = options.NetworkLayer
    if options.store?
      Vue::VueResourceForm.store = options.store

    if options.autocompletes?
      Vue::VueResourceForm.autocompletes = options.autocompletes

    if options.partials?
      Vue::VueResourceForm.partials = options.partials
}

