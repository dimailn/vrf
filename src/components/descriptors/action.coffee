import Resource from '@/mixins/resource'
import {decamelize} from 'humps'
import pluralize from 'pluralize'

export default {
  props: {
    name: String
    params: String # Query params
    data: String # Body params
  }
  mixins: [
    Resource
  ]
  methods: {
    onClick: ->
      try
        {status, data} = await @$form.executeAction(@name, {params: @params, data: @data})

        this.$emit('response', {status, data})
      catch e
        throw e unless e.status

        {status, data} = e

        @$emit('response', {status, data})
  }
}
