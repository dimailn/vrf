export default (string) ->
  firstUpperCase = string.slice(0, 1).toUpperCase()
  remainLowerCase = string.slice(1).toLowerCase()

  "#{firstUpperCase}#{remainLowerCase}"
