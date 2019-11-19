import Resource from '../../../mixins/resource'
import props from '../../prop_types/base'
import {get, set} from 'lodash'

export default {
  mixins: [Resource]
  props,

  methods:
    onInput: (e) ->
      @$emit('input', e)
    onBlur: (e) ->
      @$emit('blur', e)

    _evalBoolProp: (name) ->
      if typeof @[name] is 'string'
        return false if @[name].length == 0
        new Function('resource, rootResource, rfName', 'return resource && ' + @[name])(@resource, @$rootResource, @$rfName)
      else
        @[name]

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
}
