import Resource from '../../../mixins/resource'
import Field from '../../../mixins/field'

export default {
  mixins: [
    Resource
    Field
  ]


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


