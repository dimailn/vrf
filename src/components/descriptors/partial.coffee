import props from '@/components/prop_types/partial'
import Base from '@/components/descriptors/base'
import baseProps from '@/components/prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    ...props
  }
  computed:
    component: ->
      vue = Object.getPrototypeOf(@$root).constructor

      vue::VueResourceForm.partials[@name]
}
