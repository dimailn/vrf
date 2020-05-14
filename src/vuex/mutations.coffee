import camelCase from 'lodash.camelcase'
import set from 'lodash.set'

export default {
  'vue-resource-form:update': (state, {resourceName, name, value}) ->
    set(state[camelCase resourceName], name, value)
}