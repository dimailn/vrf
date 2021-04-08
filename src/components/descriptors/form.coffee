import capitalizeFirst from '@/utils/capitalize-first'
import pick from '@/utils/pick'
import set from '@/utils/set'
import toPath from '@/utils/to-path'
import cloneDeep from 'lodash.clonedeep'
import {camelize} from 'humps'
import VueProvideObservable from 'vue-provide-observable'

propsFactory = -> {
  resource: null
  resources: null
  $$resource: null
  disabled: false
  readonly: false
  rfName: ''
  errors: {}
  submit: null
  fetching: false
  saving: false
  vuex: false
  pathService: undefined
  rootResource: undefined
  form: null
  actionResults: {}
  actionPendings: {}
  lastSaveFailed: false
}

nameMapper = (name) ->
  switch name
    when 'resource' then '$resource'
    when 'resources' then '$resources'
    when 'errors' then '$errors'
    when 'fetching' then '$fetching'
    when 'saving' then '$saving'
    when 'actionResults' then '$actionResults'
    when 'actionPendings' then '$actionPendings'
    when 'lastSaveFailed' then '$lastSaveFailed'
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
  mixins: [VueProvideObservable('vrf', propsFactory, nameMapper)]

  provide: ->
    vueResourceFormPath: @path
    vueResourceFormPathService: @$pathService
  props:
    resource: Object
    resources: Object
    disabled: [Boolean, String]
    readonly: [Boolean, String]
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
    # If it's true, resource store is stored in vuex(mutation installation required)
    vuex:
      type: Boolean
      default: false
    # If it's true, resources have no id and are one of a kind
    single:
      type: Boolean
      default: false
    # Middleware identifier
    api:
      type: String
    # Namespace for API
    namespace:
      type: String
    # Sync prop for getting action results
    actionResults:
      type: Object
    actionPendings:
      type: Object
    # Internal service settings used for nested forms
    path: Array
    pathService: Object
    rootResource: Object

  data: ->
    innerResource: null
    innerResources: null
    innerErrors: null
    innerFetching: false
    innerSaving: false
    innerActionResults: {}
    innerActionPendings: {}
    innerLastSaveFailed: false

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

    $actionResults: ->
      @innerActionResults || @actionResults

    $actionPendings: ->
      @innerActionPendings || @actionPendings

    $lastSaveFailed: ->
      @innerLastSaveFailed

    middleware: ->
      middleware = (@VueResourceForm.middlewares || []).find((middleware) => middleware.accepts({name: @name, api: @api, namespace: @namespace}))

      throw "Can't find middleware for #{@name} resource" unless middleware

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
      @["inner#{capitalizeFirst camelize(name)}"] = value
      @$emit "update:#{name}", value

    submit: ->
      # Даем отработать onChange
      @$nextTick =>
        @$emit 'before-submit', resource: @$resource

        @$emit 'submit', resource: @$resource

        return unless @auto

        @setSyncProp 'saving', true
        @middleware.save(@$resource).then(([ok, errors]) =>
          @lastSaveFailed = !ok

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

    preserialize: ->
      resource = cloneDeep(@$resource)

      for name, children of @form.$pathService.root
        resource[name + 'Attributes'] = resource[name]

        delete resource[name]

      resource

    deserialize: (json) ->

    setResource: (resource) ->
      @setSyncProp('resource', resource)

    executeAction: (name, {params, data, method = 'post', url} = {}) ->
      @setActionPending(name, true)

      result = undefined

      @middleware.executeAction(name, {params, data, method, url})
        .then(({status, data}) => result = {status, data})
        .catch((e = {status, data}) =>
          throw e unless status

          result = {status, data}
        )
        .finally(=> @setActionResult(name, result))


    setActionResult: (name, result) ->
      @setSyncProp('actionResults', {...@$actionResults, [name]: result })
      @setActionPending(name, false)

    setActionPending: (name, inProgress) ->
      @setSyncProp('actionPendings', { ...@$actionPendings, [name]: inProgress })
}
