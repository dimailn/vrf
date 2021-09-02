var camelCase, camelCasePattern, lowerCasePattern, pattern, words;

import capitalize from './capitalize';

camelCasePattern = '([A-Z]?[a-z]+)';

lowerCasePattern = '([a-zA-Z]+)';

pattern = new RegExp(`${camelCasePattern}|${lowerCasePattern}`, 'g');

words = function(value) {
  return value.match(pattern);
};

camelCase = function(value) {
  return words(value).reduce((result, word, index) => {
    var lower;
    lower = word.toLowerCase();
    return result + (index ? capitalize(lower) : lower);
  }, '');
};

export default camelCase;
