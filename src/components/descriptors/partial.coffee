import props from '../prop_types/partial'
import Base from './base'

export default {
  extends: Base
  props
  computed:
    component: ->
      vue = Object.getPrototypeOf(@$root).constructor

      vue::VueResourceForm.partials[@name]
}
