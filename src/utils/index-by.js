export default function(array, lambda = function(value) {
    return value;
  }) {
  return array.reduce(function(index, value) {
    index[lambda(value)] = value;
    return index;
  }, {});
};
