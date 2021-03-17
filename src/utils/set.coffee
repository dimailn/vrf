export default (obj, path, value) ->
  if Object(obj) != obj then return obj

  if !Array.isArray(path)
    path = path.toString().match(/[^.[\]]+/g) || []
  path.slice(0,-1).reduce(
    (a, c, i) ->
      if Object(a[c]) == a[c]
        a[c]
      else
        a[c] =
          if Math.abs(path[i+1])>>0 == +path[i+1]
            []
          else
            {}

    obj
  )[path[path.length-1]] = value
  obj
