import Resource from '@/mixins/resource'
import set from '@/utils/set'
import get from '@/utils/get'
import evalBoolProp from '@/utils/eval-bool-prop'
import baseProps from '@/components/prop_types/base'


export default {
  mixins: [Resource]

  methods:
    onInput: (e) ->
      @$emit('input', e?.target?.value || e)
    onBlur: (e) ->
      @$emit('blur', e)
    onChange: (e) ->
      @$emit('change', e)

    t: (property, modelName = @$rfName) ->
      vue = Object.getPrototypeOf(@$root).constructor

      vue::VueResourceForm.translate(property, modelName)

  computed:
    $originalValue:
      get: ->
        return @value if @value != baseProps.value.default

        get(@$resource, @name)

      set: (value) ->
        return if baseProps.value.default != @value

        if @vuex
          store = @VueResourceForm.store
          return console.warn("Store for VueResourceForm is not defined") unless store
          store.commit('vue-resource-form:update', {resourceName: @$rfName, name: @name, value})
        else
          set(@$resource, @name, value)
    $value:
      get: ->
        @$originalValue
      set: (value ) ->
        @$originalValue = value

    $disabled: ->
      return @$formDisabled unless @disabled?

      evalBoolProp(@disabled, @)

    humanName: ->
      if @noLabel
        ''
      else
        @label || @t(@name)
}
