import './setup'

import {
  mount
} from '@vue/test-utils'

import Vue from 'vue'


describe 'scope', ->
  [
    'disabled'
    'readonly'
  ].forEach (fieldName) ->
    describe "rf-scope #{fieldName}", ->
      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource" v-slot="{ $resource }">
              <rf-scope :#{fieldName}="$resource.title.length > 0">
                <rf-input name="title" class="title" />
                <rf-textarea name="description" class="description" />
                <rf-submit class="submit" />
              </rf-scope>

              <rf-checkbox name="active" class="active" />
            </rf-form>
          """
          data: ->
            resource: {
              title: 'test'
              description: ''
            }
        )
      )

      test 'disables all inputs in scope', ->
        title = $wrapper.find('.title')
        description = $wrapper.find('.description')

        expect(title.attributes(fieldName)).toBe fieldName
        expect(description.attributes(fieldName)).toBe fieldName


      test 'doesn\'t disable input out of scope', ->
        active = $wrapper.find('.active')

        expect(active.attributes(fieldName)).not.toBe fieldName

  describe 'rf-scope isolated', ->
    def('onSaveHandler', () => jest.fn(() => Promise.resolve([true, {}])))
    def('savingWatcher', () => jest.fn())
    def('scopeSavingWatcher', () => jest.fn())

    def('wrapper', ->
      mount(
        template: """
          <rf-form
            :resource="resource"
            :saving.sync="saving"
            v-slot="{ $resource }"
            :auto="effect"
            no-fetch
            :rf-id="1"
            name="Test"
          >
            <rf-scope :isolated="isolated" :saving.sync="scopeSaving">
              <rf-input name="title" class="title" />
              <rf-textarea name="description" class="description" />
              <rf-submit class="submit" />
            </rf-scope>

            <rf-checkbox name="active" class="active" />
          </rf-form>
        """
        data: ->
          resource: {
            title: 'test'
            description: ''
            active: false
          },
          isolated: $isolated
          saving: false
          scopeSaving: false
        watch:
          saving: $savingWatcher
          scopeSaving: $scopeSavingWatcher
        computed:
          effect: ->
            ({onSave}) => onSave($onSaveHandler)
      )
    )

    def('submit', -> $wrapper.find('.submit'))

    beforeEach ->
      $submit.trigger('click')

    describe 'true', ->
      def('isolated', -> true)

      test 'changes scope saving flag', ->
        expect($scopeSavingWatcher).toHaveBeenCalled()

      test 'doesnt change form saving flag', ->
        expect($savingWatcher).not.toHaveBeenCalled()

      test 'saves only scope data', ->
        expect($onSaveHandler).toHaveBeenCalledWith({
          title: 'test',
          description: ''
        })

    describe 'false', ->
      def('isolated', -> false)

      test 'changes scope saving flag', ->
        expect($scopeSavingWatcher).not.toHaveBeenCalled()

      test 'change form saving flag', ->
        expect($savingWatcher).toHaveBeenCalled()

      test 'saves all data', ->
        expect($onSaveHandler).toHaveBeenCalledWith({
          title: 'test',
          description: '',
          active: false
        })



  describe 'rf-scope autosave', ->
    def('onSaveHandler', () => jest.fn(() => Promise.resolve([true, {}])))
    def('wrapper', ->
      mount(
        template: """
          <rf-form
            :resource="resource"
            v-slot="{ $resource }"
            :auto="effect"
            no-fetch
            :rf-id="1"
            name="Test"
          >
            <rf-scope isolated autosave>
              <rf-input name="title" class="title" />
              <rf-textarea name="description" class="description" />
            </rf-scope>

            <rf-checkbox name="active" class="active" />
          </rf-form>
        """
        data: ->
          resource: {
            title: 'test'
            description: ''
            active: false
          }
        computed:
          effect: ->
            ({onSave}) => onSave($onSaveHandler)
      )
    )

    def('input', -> $wrapper.find('.title'))

    beforeEach ->
      $input.setData($value: "Test")

    test 'saves data after one second', ->
      await new Promise((resolve) -> setTimeout(resolve, 1000))
      expect($onSaveHandler).toHaveBeenCalledWith({
        title: 'Test',
        description: ''
      })




