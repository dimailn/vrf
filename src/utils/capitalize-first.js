export default function(string) {
  var firstUpperCase;
  firstUpperCase = string.slice(0, 1).toUpperCase();
  return `${firstUpperCase}${string.slice(1)}`;
};
