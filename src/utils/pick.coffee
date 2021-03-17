export default (object, keys) ->
  keys.reduce(
    (obj, key) ->
      if object && key of object
        obj[key] = object[key]

      obj
   {}
  )