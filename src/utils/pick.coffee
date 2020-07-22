export default (object, keys) ->
  keys.reduce(
    (obj, key) ->
      if object && object.hasOwnProperty(key)
        obj[key] = object[key]

      obj
   {}
  )