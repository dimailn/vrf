import Base from './base'
import baseProps from '../prop_types/base'

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
      errors: @$errors
    }
    @$scopedSlots?.default?(props)?[0]
}


