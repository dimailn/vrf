var lz;

lz = function(v) {
  if (v > 9) {
    return v;
  }
  return `0${v}`;
};

export default {
  in: function(date) {
    return new Date(date);
  },
  out: function(value) {
    if (!value) {
      return;
    }
    return value.getFullYear() + '-' + lz(value.getMonth() + 1) + '-' + lz(value.getDate()) + 'T' + lz(value.getHours()) + ':' + lz(value.getMinutes());
  }
};
