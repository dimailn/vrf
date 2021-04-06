import evalBoolProp from '@/utils/eval-bool-prop'

export default {
  inject: ['vrf']
  computed:
    $resource: ->
      @vrf.wrapper.resource

    $sources: ->
      @vrf.wrapper.resources

    resource: ->
      console.warn '[vrf] Field resource in Resource mixin deprecated, use $resource instead.'
      @$resource

    resources: ->
      console.warn '[vrf] Field resources in Resource mixin deprecated, use $sources instead.'
      @$sources

    $formDisabled: ->
      evalBoolProp(@vrf.wrapper.disabled, @)

    formDisabled: ->
      console.warn '[vrf] Field formDisabled in Resource mixin deprecated, use $formDisabled instead.'
      @$formDisabled

    $formReadonly: ->
      evalBoolProp(@vrf.wrapper.readonly, @)

    fetching: ->
      @vrf.wrapper.fetching

    vuex: ->
      @vrf.wrapper.vuex

    pathService: ->
      @vrf.wrapper.pathService

    $rfName: ->
      @vrf.wrapper.rfName

    $errors: ->
      @vrf.wrapper.errors

    $submit: ->
      @vrf.wrapper.submit

    $saving: ->
      @vrf.wrapper.saving

    $form: ->
      @vrf.wrapper.form

    rootResource: ->
      console.warn '[vrf] Field rootResource in Resource mixin deprecated, use $rootResource instead.'
      @$rootResource

    $rootResource: ->
      @vrf.wrapper.rootResource || @$resource

    $actionResults: ->
      @vrf.wrapper.actionResults

    $actionPendings: ->
      @vrf.wrapper.actionPendings
}
