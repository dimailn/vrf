import Base from '@/components/descriptors/base'
import baseProps from '@/components/prop_types/base'

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


