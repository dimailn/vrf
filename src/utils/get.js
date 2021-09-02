export default function(obj, path, defaultValue = void 0) {
  var result, travel;
  travel = function(regexp) {
    return String.prototype.split.call(path, regexp).filter(Boolean).reduce(function(res, key) {
      if (res !== null && res !== void 0) {
        return res[key];
      } else {
        return res;
      }
    }, obj);
  };
  result = travel(/[,[\]]+?/) || travel(/[,[\].]+?/);
  if (result === void 0 || result === obj) {
    return defaultValue;
  } else {
    return result;
  }
};