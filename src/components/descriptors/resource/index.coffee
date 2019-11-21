import Base from '../base'

export default {
  extends: Base


  render: ->
    props = {
      resource: @resource
      resources: @resources
      rootResource: @$rootResource
      rootResources: @$rootResources
      disabled: @formDisabled
      tScope: @tScope
      t: @t
    }
    @$scopedSlots.default(props)[0]
}


