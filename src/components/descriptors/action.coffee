import Resource from '@/mixins/resource'
import Translate from '@/mixins/translate'

export default {
  props: {
    name: String
    params: String # Query params
    data: String # Body params
    method: String # Request HTTP method
    url: String # Override default based on name
  }
  mixins: [
    Resource
    Translate
  ]
  computed:
    humanName: ->
      @t("$actions.#{@name}")

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
        .then((result) => @$emit('result', result))

  }
}
