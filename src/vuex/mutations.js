import set from '@/utils/set';

import camelCase from '../utils/camel-case';

export default {
  'vue-resource-form:set': function(state, {resourceName, payload}) {
    state[camelCase(resourceName)] = payload;
  },
  'vue-resource-form:update': function(state, {resourceName, name, value}) {
    set(state[camelCase(resourceName)], name, value);
  }
};
