export default function(string) {
  var firstUpperCase, remainLowerCase;
  firstUpperCase = string.slice(0, 1).toUpperCase();
  remainLowerCase = string.slice(1).toLowerCase();
  return `${firstUpperCase}${remainLowerCase}`;
};
