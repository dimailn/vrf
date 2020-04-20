export default {
  inject: ['vueResourceForm']
  computed:
    resource: ->
      @vueResourceForm.wrapper.resource

    resources: ->
      @vueResourceForm.wrapper.resources

    formDisabled: ->
      @vueResourceForm.wrapper.disabled

    submit: ->
      @vueResourceForm.wrapper.submit

    requireSource: ->
      @vueResourceForm.wrapper.requireSource

    saving: ->
      @vueResourceForm.wrapper.saving

    fetching: ->
      @vueResourceForm.wrapper.fetching

    vuex: ->
      @vueResourceForm.wrapper.vuex

    $rfName: ->
      @vueResourceForm.wrapper.rfName

    errors: ->
      @vueResourceForm.wrapper.errors

    pathService: ->
      @vueResourceForm.wrapper.pathService

    rootResource: ->
      @vueResourceForm.wrapper.rootResource

    $rootResource: ->
      @rootResource || @resource
}
