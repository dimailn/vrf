export default function(obj, path, value, setFunction = function(obj, key, value) {
    return obj[key] = value;
  }) {
  if (Object(obj) !== obj) {
    return obj;
  }
  if (!Array.isArray(path)) {
    path = path.toString().match(/[^.[\]]+/g) || [];
  }
  setFunction(path.slice(0, -1).reduce(function(a, c, i) {
    if (Object(a[c]) === a[c]) {
      return a[c];
    } else {
      return setFunction(a, c, Math.abs(path[i + 1]) >> 0 === +path[i + 1] ? [] : {});
    }
  }, obj), path[path.length - 1], value);
  return obj;
};
