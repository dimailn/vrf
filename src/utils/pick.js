import get from 'lodash.get'
import set from 'lodash.set'

export default function(object, keys) {
  return keys.reduce(function(obj, key) {
    if(object){
      set(obj, key, get(object, key))
    }
    return obj;
  }, {});
};
