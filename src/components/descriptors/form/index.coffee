import VueProvideObservable from 'vue-provide-observable'
import capitalize from 'lodash.capitalize'

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
  rfName: ''
  pathService: undefined
  rootResource: undefined
}

nameMapper = (name) ->
  switch name
    when 'resource' then '$resource'
    when 'resources' then '$resources'
    when 'errors' then '$errors'
    when 'fetching' then '$fetching'
    when 'saving' then '$saving'
    else name


import set from 'lodash.set'

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
    rfName: String
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

    networkLayer: ->
      new @VueResourceForm.NetworkLayer(@rfName, @)

    $pathService: ->
      window.pathService = @pathService || new PathService


  methods:
    forceReload: ->
      return unless @auto

      throw "You must provide rfName for auto-forms." unless @rfName
      throw "You must provide NetworkLayer for auto-forms." unless @VueResourceForm.NetworkLayer

      if @noFetch
        resources = await @networkLayer.loadSources()
        @setSyncProp 'resources', resources
        return

      @$emit 'before-load'
      try
        @setSyncProp 'fetching', true
        [resource, resources] = await @networkLayer.load()
      finally
        @setSyncProp 'errors', {}
        @setSyncProp 'fetching', false

      @innerResource = resource
      @$emit 'update:resource', @innerResource if @innerResource?

      @setSyncProp 'resources', resources

      @$emit 'after-load-success'

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
        [ok, errors] = await @networkLayer.save(@$resource)
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

    deserialize: (json) ->

    setResource: (resource) ->
      @setSyncProp('resource', resource)

}
