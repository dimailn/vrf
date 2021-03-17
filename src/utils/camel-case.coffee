import capitalize from './capitalize'

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