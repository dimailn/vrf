import evalBoolProp from '@/utils/eval-bool-prop'

export default {
  inject: ['$vpo']
  computed:
    $resource: ->
      @$vpo.wrapper.vrf.resource

    $sources: ->
      @$vpo.wrapper.vrf.resources

    resource: ->
      console.warn '[vrf] Field resource in Resource mixin deprecated, use $resource instead.'
      @$resource

    resources: ->
      console.warn '[vrf] Field resources in Resource mixin deprecated, use $sources instead.'
      @$sources

    $formDisabled: ->
      evalBoolProp(@$vpo.wrapper.vrf.disabled, @)

    formDisabled: ->
      console.warn '[vrf] Field formDisabled in Resource mixin deprecated, use $formDisabled instead.'
      @$formDisabled

    $formReadonly: ->
      evalBoolProp(@$vpo.wrapper.vrf.readonly, @)

    fetching: ->
      @$vpo.wrapper.vrf.fetching

    vuex: ->
      @$vpo.wrapper.vrf.vuex

    pathService: ->
      @$vpo.wrapper.vrf.pathService

    $rfName: ->
      @$vpo.wrapper.vrf.rfName

    $errors: ->
      @$vpo.wrapper.vrf.errors

    $submit: ->
      @$vpo.wrapper.vrf.submit

    $saving: ->
      @$vpo.wrapper.vrf.saving

    $form: ->
      @$vpo.wrapper.vrf.form

    rootResource: ->
      console.warn '[vrf] Field rootResource in Resource mixin deprecated, use $rootResource instead.'
      @$rootResource

    $rootResource: ->
      @$vpo.wrapper.vrf.rootResource || @$resource

    $actionResults: ->
      @$vpo.wrapper.vrf.actionResults

    $actionPendings: ->
      @$vpo.wrapper.vrf.actionPendings
}
