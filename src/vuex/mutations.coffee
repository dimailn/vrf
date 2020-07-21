import set from 'lodash.set'

camelCase = (str) ->
  str.toLowerCase().replace /[^a-zA-Z0-9]+(.)/g, (m, chr) ->
    chr.toUpperCase()

export default {
  'vue-resource-form:update': (state, {resourceName, name, value}) ->
    set(state[camelCase resourceName], name, value)
}