import Resource from '@/mixins/resource'
import set from '@/utils/set'
import get from '@/utils/get'


export default {
  mixins: [Resource]

  methods:
    onInput: (e) ->
      @$emit('input', e)
    onBlur: (e) ->
      @$emit('blur', e)
    onChange: (e) ->
      @$emit('change', e)

    _evalBoolProp: (name) ->
      if typeof @[name] is 'string'
        return false if @[name].length == 0
        new Function('resource, rootResource, rfName', 'return resource && ' + @[name])(@resource, @$rootResource, @$rfName)
      else
        @[name]

    t: (property, modelName = @$rfName) ->
      vue = Object.getPrototypeOf(@$root).constructor

      vue::VueResourceForm.translate(property, modelName)

  computed:
    # $value!!!
    value:
      get: ->
        get(@resource, @name)

      set: (value) ->
        if @vuex
          store = @VueResourceForm.store
          return console.warn("Store for VueResourceForm is not defined") unless store
          store.commit('vue-resource-form:update', {resourceName: @$rfName, name: @name, value})
        else
          set(@resource, @name, value)
    $disabled: ->
      return @_evalBoolProp('formDisabled') unless @disabled?

      @_evalBoolProp('disabled')

    $formDisabled: ->
      @_evalBoolProp('formDisabled')

    humanName: ->
      if @noLabel
        ''
      else
        @label || @t(@name)
}
