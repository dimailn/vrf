import {camelCase, set} from 'lodash'

export default {
  'vue-resource-form:update': (state, {resourceName, name, value}) ->
    set(state[camelCase resourceName], name, value)
}