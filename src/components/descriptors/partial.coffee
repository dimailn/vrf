import props from '../prop_types/partial'
import Base from './base'
import baseProps from '../../prop_types/base'

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
