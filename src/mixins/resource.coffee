import evalBoolProp from '@/utils/eval-bool-prop'

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

    $formDisabled: ->
      evalBoolProp(@vueResourceForm.wrapper.disabled, @)

    formDisabled: ->
      console.warn '[vrf] Field formDisabled in Resource mixin deprecated, use $formDisabled instead.'
      @$formDisabled

    $formReadonly: ->
      evalBoolProp(@vueResourceForm.wrapper.readonly, @)

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
      console.warn '[vrf] Field rootResource in Resource mixin deprecated, use $rootResource instead.'
      @$rootResource

    $rootResource: ->
      @vueResourceForm.wrapper.rootResource || @$resource

    $actionResults: ->
      @vueResourceForm.wrapper.actionResults

    $actionPendings: ->
      @vueResourceForm.wrapper.actionPendings
}
