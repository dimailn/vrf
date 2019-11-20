import {decamelize} from 'humps'

import FieldProps from '../components/prop_types/field'

export default {
  inject: ['vueResourceForm']

  props: FieldProps

  methods:
    t: (property) ->
      vue = Object.getPrototypeOf(@$root).constructor

      vue::VueResourceForm.translate(property, @rfName)

  computed:
    humanName: ->
      if @noLabel
        ''
      else
        @label || @t(@name)


    isRequired: ->
      @rules && @rules.indexOf('required') != -1

    rfName: ->
      @vueResourceForm.wrapper.rfName

    errors: ->
      @vueResourceForm.wrapper.errors
}
