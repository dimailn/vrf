export default (array, lambda = (value) -> value) ->
  array.reduce(
    (index, value) -> index[lambda(value)] = value; index
    {}
  )
