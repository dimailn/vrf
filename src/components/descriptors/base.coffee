import Resource from '@/mixins/resource'
import set from '@/utils/set'
import get from '@/utils/get'
import evalBoolProp from '@/utils/eval-bool-prop'
import Translate from '@/mixins/translate'

export default {
  mixins: [
    Resource
    Translate
  ]

  methods:
    onInput: (e) ->
      @$emit('input', e)
    onBlur: (e) ->
      @$emit('blur', e)
    onChange: (e) ->
      @$emit('change', e)

  computed:
    $fieldName: -> @name
    $originalValue:
      get: ->
        get(@$resource, @$fieldName)

      set: (value) ->
        if @vuex
          store = @VueResourceForm.store
          return console.warn("Store for VueResourceForm is not defined") unless store
          store.commit('vue-resource-form:update', {resourceName: @$rfName, name: @$fieldName, value})
        else
          set(@$resource, @$fieldName, value)

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

    $originalDisabled: ->
      return @$formDisabled unless @disabled?

      evalBoolProp(@disabled, @)

    $disabled: ->
      @$originalDisabled

    $originalReadonly: ->
      return @$formReadonly unless @readonly?

      evalBoolProp(@readonly, @)

    $readonly: ->
      @$originalReadonly

    humanName: ->
      if @noLabel
        ''
      else
        @label || @t(@name)
}
