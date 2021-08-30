import Base from '@/components/descriptors/base'

export default {
  extends: Base
  render: ->
    props = {
      resource: @$resource
      resources: @$sources
      rootResource: @$rootResource
      rootResources: @$rootResources
      disabled: @$formDisabled
      tScope: @tScope
      t: @t
      errors: @$errors
      actionResults: @$actionResults
    }
    @$scopedSlots?.default?(props)?[0]
}


