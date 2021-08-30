import Base from '@/components/descriptors/base'

export default {
  extends: Base
  props: {
    name: String
    callback: Function
  }
  computed:
    component: ->
      vue = Object.getPrototypeOf(@$root).constructor

      vue::VueResourceForm.partials[@name]
}
