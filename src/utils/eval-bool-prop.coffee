export default (propValue, resourceHolder) ->
  if typeof propValue is 'string'
    return false if propValue.length == 0
    new Function('resource, rootResource, rfName, $resource, $rootResource, $rfName', 'return resource && ' + propValue)(
      resourceHolder.$resource
      resourceHolder.$rootResource
      resourceHolder.$rfName
      resourceHolder.$resource
      resourceHolder.$rootResource
      resourceHolder.$rfName
    )
  else
    propValue