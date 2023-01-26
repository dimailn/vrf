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
      def('listenersMap', -> {})

      beforeEach ->
        document.addEventListener = jest.fn((event, cb) =>
          $listenersMap[event] = cb
        )

      def('componentOnSelect', -> jest.fn())
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
                @select="onSelect"
              />
            </rf-form>
          """
          data: ->
            resource: {
              title: ''
            }
          methods:
            onSelect: $componentOnSelect
        )
      )

      def('onLoad', => jest.fn -> Promise.resolve([
        {
          id: 1
          title: 'Some text'
        }
      ]))

      def('onMounted', -> jest.fn())

      def('onSelect', -> jest.fn())

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad, onMounted, onSelect}) ->
            onLoad($onLoad)
            onMounted($onMounted)
            onSelect($onSelect)
        }
      ])

      def('autocomplete', -> $wrapper.find('.autocomplete'))

      def('input', -> $wrapper.find('input'))

      beforeEach -> $wrapper

      test 'calls onMounted', ->
        expect($onMounted).toHaveBeenCalled()

      describe 'on user input autocomplete', ->
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

        describe 'on item clicked', ->
          beforeEach ->
            $wrapper.find('li').trigger('click')

          test 'calls onSelect in provider', ->
            expect($onSelect).toHaveBeenCalledWith(id: 1, title: 'Some text')

          test 'calls onSelect in component', ->
            expect($componentOnSelect).toHaveBeenCalledWith(id: 1, title: 'Some text')

        describe 'on document clicked', ->
          beforeEach ->
            $listenersMap.click(target: $wrapper.find('form').element)

          test 'doesnt show suggestion', ->
            expect($wrapper.text()).not.toContain('Some text')