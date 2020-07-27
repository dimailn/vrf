export default (object, keys) ->
  keys.reduce(
    (obj, key) ->
      if object && key in object
        obj[key] = object[key]

      obj
   {}
  )