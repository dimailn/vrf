export default (obj, path, defaultValue = undefined) ->
  travel = (regexp) ->
    String.prototype.split
      .call(path, regexp)
      .filter(Boolean)
      .reduce(
        (res, key) -> if res != null && res != undefined then res[key] else res
        obj
      )

  result = travel(/[,[\]]+?/) || travel(/[,[\].]+?/)
  if result == undefined || result == obj then defaultValue else result
