import {decamelize} from 'humps'

# Функция для переводов должна устанавливаться глобально
t = (property, rfName) ->
  rfName = rfName.split("::")[0] if rfName
  scope = "activerecord.attributes.#{decamelize(rfName)}" if rfName
  I18n.t(decamelize(property), scope: scope, defaultValue: I18n.t "attributes.#{decamelize property}")

import FieldProps from '../components/prop_types/field'

export default {
  inject: ['vueResourceForm']

  props: FieldProps

  methods:
    t: (property) ->
      t(property, @rfName)

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
