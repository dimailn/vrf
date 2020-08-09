import Resource from '@/mixins/resource'
import set from '@/utils/set'
import get from '@/utils/get'
import evalBoolProp from '@/utils/eval-bool-prop'


export default {
  mixins: [Resource]

  methods:
    onInput: (e) ->
      @$emit('input', e)
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
        get(@$resource, @name)

      set: (value) ->
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
    value:
      get: ->
        console.warn '[vrf] Value computed prop is deprecated, use $value instead'
        @$value
      set: (value) ->
        console.warn '[vrf] Value computed prop is deprecated, use $value instead'
        @$value = value
    $disabled: ->
      return @$formDisabled unless @disabled?

      evalBoolProp(@disabled, @)

    humanName: ->
      if @noLabel
        ''
      else
        @label || @t(@name)
}
