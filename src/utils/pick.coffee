import get from './get'
import set from './set'

export default (object, keys) ->
  keys.reduce(
    (obj, key) ->
      # if object && key of object
      set(obj, key, get(object, key))

      obj
   {}
  )