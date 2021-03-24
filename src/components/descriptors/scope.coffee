import Base from '@/components/descriptors/base'
import baseProps from '@/components/prop_types/base'
import evalBoolProp from '@/utils/eval-bool-prop'

export default {
  extends: Base
  props:
    rfIf: [Boolean, String]
    wrapper:
      type: String
      default: 'div'
    disabled: [Boolean, String]
    readonly: [Boolean, String]

  render: (h) ->
    return unless @visible

    nodes = @$slots?.default

    h(
      'rf-form'
      {
        props:
          name: @$rfName
          resource: @$resource
          sources: @$sources
          errors: @$errors
          vuex: @$vuex
          pathService: @vueResourceFormPathService
          rootResource: @$rootResource
          disabled: @scopeDisabled
          readonly: @scopeReadonly

        on:
          'reload-resource': @$form.reloadResource()
          'reload-root-resource': @$form.reloadRootResource()
          'reload-sources': @$form.reloadSources()
      }
      nodes
    )


  computed:
    scopeDisabled: ->
      @$formDisabled || @disabled
    scopeReadonly: ->
      @$formReadonly || @readonly
    visible: ->
      evalBoolProp(@rfIf, @)
}
