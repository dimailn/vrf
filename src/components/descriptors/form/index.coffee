import VueProvideObservable from 'vue-provide-observable'
import capitalize from '../../../utils/capitalize'
import pick from '../../../utils/pick'
import set from '../../../utils/set'
import toPath from '../../../utils/to-path'


provideProps = -> {
  resource: null
  resources: null
  $$resource: null
  disabled: false
  rfName: ''
  errors: {}
  submit: null
  fetching: false
  saving: false
  vuex: false
  pathService: undefined
  rootResource: undefined
  form: null
}

nameMapper = (name) ->
  switch name
    when 'resource' then '$resource'
    when 'resources' then '$resources'
    when 'errors' then '$errors'
    when 'fetching' then '$fetching'
    when 'saving' then '$saving'
    else name


# import set from 'lodash.set'

class PathService
  constructor: ->
    @root = {}

  add: (parentPath, name) ->
    if parentPath
      set(@root, parentPath, {"#{name}": {}})
    else
      @root[name] = {}



export default {
  mixins: [VueProvideObservable('vueResourceForm', provideProps, nameMapper)]
  provide: ->
    vueResourceFormPath: @path
    vueResourceFormPathService: @$pathService
  props:
    resource: Object
    resources: Object
    disabled: [Boolean, String]
    name: String
    rfId: Number
    rootName: String
    auto:
      type: Boolean
      default: false
    implicit:
      type: Boolean
      default: false
    noFetch:
      type: Boolean
      default: false
    errors:
      type: Object
      default: -> {}
    fetching: Boolean
    saving: Boolean
    path: Array
    pathService: Object
    rootResource: Object
    vuex:
      type: Boolean
      default: false
    single:
      type: Boolean
      default: false
    transport:
      type: String

  data: ->
    innerResource: null
    innerResources: null
    innerErrors: null
    innerFetching: false
    innerSaving: false

  watch:
    rfId: ->
      @forceReload()
    resource: (old, current) ->
      return if old == current

      @innerResource = null


  mounted: ->
    @forceReload()

  computed:
    tailPath: ->
      return unless @path

      lastElement = @path[@path.length - 1]

      if typeof lastElement is 'number'
        [@path[@path.length - 2], lastElement]
      else
        [lastElement]

    form: ->
      @
    rfName: ->
      @name
    $$resource: ->
      @resource
    $resource: ->
      @innerResource || @resource

    $resources: ->
      @innerResources || @resources || {}

    $errors: ->
      @innerErrors || @errors

    $fetching: ->
      @innerFetching || @fetching

    $saving: ->
      @innerSaving || @saving

    middleware: ->
      middleware = @VueResourceForm.middlewares.find((middleware) => middleware.accepts({name: @name, transport: @transport}))

      throw "Can't find middleware for #{@name}" unless middleware

      new middleware(@rfName, @)

    $pathService: ->
      window.pathService = @pathService || new PathService

    isReloadPossible: ->
      @auto || @path?

    isNested: ->
      !!@path

  methods:
    forceReload: ->
      return unless @auto

      throw "You must provide name for auto-forms." unless @name
      throw "You must provide middlewares for auto-forms." unless @VueResourceForm.middlewares

      if @noFetch
        @reloadSources()
        return

      @$emit 'before-load'

      @setSyncProp 'fetching', true

      Promise.all([
        @reloadSources()
        @reloadResource()
      ])
      .then => @$emit 'after-load-success'
      .finally(
        =>
          @setSyncProp 'errors', {}
          @setSyncProp 'fetching', false
      )


    reloadSources: ->
      return console.warn "Reload methods is applicable only to auto-forms" unless @isReloadPossible

      return @$emit('reload-sources') if @isNested

      @middleware.loadSources().then((resources) =>
        @setSyncProp 'resources', resources
      )

    reloadResource: (modifier) ->
      return console.warn "Reload methods is applicable only to auto-forms" unless @isReloadPossible

      if @isNested
        if @tailPath
          nestedPath = toPath(@tailPath)

          modifier =
            if modifier instanceof Array
              modifier.map (m) -> "#{nestedPath}.#{m}"
            else
              nestedPath

        return @$emit('reload-resource', modifier)

      @reloadRootResource(modifier)

    reloadRootResource: (modifier) ->
      return @$emit('reload-root-resource', modifier) if @isNested

      @middleware.load().then((resource) =>
        if !modifier || !@innerResource
          @innerResource = resource
        else
          throw 'Modifier must be an array' unless modifier instanceof Array

          # must be deep merge
          @innerResource = {
            ...@innerResource
            ...pick(resource, modifier)
          }


        @$emit 'update:resource', @innerResource if @innerResource?
      )

    setSyncProp: (name, value) ->
      @["inner#{capitalize name}"] = value
      @$emit "update:#{name}", value

    submit: ->
      # Даем отработать onChange
      @$nextTick =>
        @$emit 'before-submit'

        @$emit 'submit'

        return unless @auto

        @setSyncProp 'saving', true
        @middleware.save(@$resource).then(([ok, errors]) =>
          @setSyncProp 'saving', false

          @setSyncProp(
            'errors'
            if ok then {} else errors
          )

          @$emit('after-submit')
          @$emit(
            if ok
              'after-submit-success'
            else
              'after-submit-failure'
          )
        ).catch(console.error)

    deserialize: (json) ->

    setResource: (resource) ->
      @setSyncProp('resource', resource)

}
