import Resource from '@/mixins/resource'
import base from '@/components/descriptors/base'

export default {
  extends: base
  inject: [
    'vueResourceFormPath'
    'vueResourceFormPathService'
  ]

  mixins: [
    Resource
  ]

  props:
    name: String
    rfName: String
    index: Number
    filter: Function
    schema: Array
    wrapper:
      type: String
      default: 'div'


  computed:
    isCollection: ->
      @nestedResource instanceof Array

    collection: ->
      baseCollection = @nestedResource.filter((r) -> !r._destroy)

      baseCollection = baseCollection.filter(@filter) if @filter

      baseCollection

    wrappedCollection: ->
      @collection.map (item, index) -> { index, item }

    nestedResource: ->
      @$resource && @$resource[@name]

    parentPath: ->
      @vueResourceFormPathService.add(@vueResourceFormPath, @name)

      return [@name] unless @vueResourceFormPath

      @vueResourceFormPath.concat([@name])

    pathService: ->
      @vueResourceFormPathService

    errorsForNestedResource: ->
      @$errors && @$errors[@name]

    $schema: ->
      @schema || @defaultSchema

    defaultSchema: ->
      [ => @wrappedCollection]

  methods:
    reloadResource: (modifier) ->
      @$form.reloadResource(modifier)

    reloadSources: ->
      @$form.reloadSources()

    reloadRootResource: (modifier) ->
      @$form.reloadRootResource(modifier)

    errorsFor: (index) ->
      return unless @$errors

      prefix = @name + "[#{index}]"

      errors =
        Object.keys(@$errors)
          .filter((path) -> path.substr(0, prefix.length) == prefix)
          .reduce(
            (ownErrors, path) => ownErrors[path[prefix.length + 1 ...]] = @$errors[path]; ownErrors
            {}
          )

      errors


    pathFor: (index) ->
      @parentPath.concat([index])
}