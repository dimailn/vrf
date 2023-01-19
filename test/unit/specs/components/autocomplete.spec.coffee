import './setup'

import {
  mount
} from '@vue/test-utils'

import Vue from 'vue'

describe 'autocomplete', ->
  beforeEach ->
    Vue::VueResourceForm.autocompletes = $autocompletes

  def('autocompletes', => [])

  describe 'with provider', ->
    describe 'with specified title-key', ->
      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: {
              title: ''
            }
        )
      )

      def('onLoad', => jest.fn -> Promise.resolve([
        {
          id: 1
          title: 'Some text'
        }
      ]))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad}) ->
            onLoad($onLoad)
        }
      ])

      def('autocomplete', -> $wrapper.find('.autocomplete'))

      def('input', -> $wrapper.find('input'))


      beforeEach ->
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))

      test 'calls onLoad with query', ->
        expect($onLoad).toHaveBeenCalledWith({
          query: 'test',
          entity: 'todo',
          limit: undefined
        })

      test 'contains items', ->
        expect($wrapper.vm.$refs.autocomplete.items).toEqual(
          [
            {
              id: 1
              title: 'Some text'
            }
          ]
        )

      test 'shows suggestion', ->
        expect($wrapper.text()).toContain('Some text')
