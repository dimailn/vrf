export default {
  inject: ['vueResourceForm']
  computed:
    $resource: ->
      @vueResourceForm.wrapper.resource

    $sources: ->
      @vueResourceForm.wrapper.resources

    resource: ->
      console.warn '[vrf] Field resource in Resource mixin deprecated, use $resource instead.'
      @$resource

    resources: ->
      console.warn '[vrf] Field resources in Resource mixin deprecated, use $sources instead.'
      @$sources

    formDisabled: ->
      @vueResourceForm.wrapper.disabled

    fetching: ->
      @vueResourceForm.wrapper.fetching

    vuex: ->
      @vueResourceForm.wrapper.vuex

    pathService: ->
      @vueResourceForm.wrapper.pathService

    $rfName: ->
      @vueResourceForm.wrapper.rfName

    $errors: ->
      @vueResourceForm.wrapper.errors

    $submit: ->
      @vueResourceForm.wrapper.submit

    $saving: ->
      @vueResourceForm.wrapper.saving

    $form: ->
      @vueResourceForm.wrapper.form
 
    rootResource: ->
      @vueResourceForm.wrapper.rootResource

    $rootResource: ->
      @rootResource || @resource
}
