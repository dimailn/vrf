import Base from '../base'
import baseProps from '../../prop_types/base'

export default {
  extends: Base
  render: ->
    console.log @$scopedSlots
    props = {
      resource: @resource
      resources: @resources
      rootResource: @$rootResource
      rootResources: @$rootResources
      disabled: @formDisabled
      tScope: @tScope
      t: @t
    }
    @$scopedSlots?.default?(props)?[0]
}


