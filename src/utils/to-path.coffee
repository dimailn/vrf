export default (elements) ->
  elements.reduce(
    (path, element, i) ->
      path +=
        if typeof element is 'number'
          "[#{element}]"
        else
          if i == 0 then element else ".#{element}"
    ""
  )