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



