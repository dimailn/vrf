import props from '../prop_types/partial'
import Base from './base'
import Vue from 'vue'

export default {
  extends: Base
  props
  computed:
    component: ->
      Vue::VueResourceForm.partials[@name]
}
