capitalize = (string) ->
  firstUpperCase = string.slice(0, 1).toUpperCase()
  remainLowerCase = string.slice(1).toLowerCase()

  "#{firstUpperCase}#{remainLowerCase}"


camelCasePattern = '([A-Z]?[a-z]+)'
lowerCasePattern = '([a-zA-Z]+)'

pattern = new RegExp("#{camelCasePattern}|#{lowerCasePattern}", 'g')

words = (value) ->
  value.match(pattern)


camelCase = (value) ->
  words(value).reduce(
    (result, word, index) =>
      lower = word.toLowerCase()
      result + (if index then capitalize(lower) else lower)
    ''
  )

export default camelCase