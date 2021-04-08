import Resource from '@/mixins/resource'
import Translate from '@/mixins/translate'

export default {
  props: {
    name: String
    params: Object # Body params
    method: String # Request HTTP method
    url: String # Override default based on name
    label: String
    labelName: String
    reloadOnResult: Boolean
  }
  mixins: [
    Resource
    Translate
  ]
  computed:
    humanName: ->
      return @label if @label

      @t("$actions.#{@labelName || @name}")

  render: (h) ->
    events = {click: @onClick}
    if @$scopedSlots.activator
      nodes = @$scopedSlots['activator']({humanName: @humanName, on: events, pending: @$actionPendings[@name] || false})

      if nodes.length > 1
        h('div', null, nodes)
      else
        nodes
    else
      h('button', {on: events}, @humanName)


  methods: {
    onClick: ->
      @$form.executeAction(@name, {params: @params, data: @data, method: @method, url: @url})
        .then((result) =>
          @$form.reloadResource() if @reloadOnResult

          @$emit('result', result)
        )

  }
}
