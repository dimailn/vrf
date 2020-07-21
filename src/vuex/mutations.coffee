import set from 'lodash.set'

import camelCase from '../utils/camel-case'

export default {
  'vue-resource-form:update': (state, {resourceName, name, value}) ->
    set(state[camelCase resourceName], name, value)
}