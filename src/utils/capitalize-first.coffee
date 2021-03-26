export default (string) ->
  firstUpperCase = string.slice(0, 1).toUpperCase()

  "#{firstUpperCase}#{string.slice(1)}"
