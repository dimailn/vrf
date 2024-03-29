export default function(elements) {
  return elements.reduce(function(path, element, i) {
    return path += typeof element === 'number' ? `[${element}]` : i === 0 ? element : `.${element}`;
  }, "");
};
