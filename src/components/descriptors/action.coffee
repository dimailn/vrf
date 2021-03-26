import Resource from '@/mixins/resource'
import Translate from '@/mixins/translate'

export default {
  props: {
    name: String
    params: String # Query params
    data: String # Body params
    method: String # Request HTTP method
  }
  mixins: [
    Resource
    Translate
  ]
  computed:
    humanName: ->
      @t("$actions.#{@name}")

  methods: {
    onClick: ->
      @$form.executeAction(@name, {params: @params, data: @data, method: @method})
        .then((result) => @$emit('response', result))

  }
}
