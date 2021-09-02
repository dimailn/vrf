import {
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import Vue from 'vue'

Vue.use(Vrf)

describe 'nested', ->
  def('errors', -> {})
  def('wrapper', ->
    mount(
      template: $template
      data: ->
        errors: $errors
        resource: $resource

    )
  )
  describe "array", ->
    def('template', ->
      '''
        <rf-form :resource="resource" :errors="errors" ref="form">
          <rf-input name="title" />
          <rf-nested name="subtasks">
            <template slot-scope="props">
              <rf-input name="title" class="subtask-title" ref="input" />
              <rf-input name="deadline" />
            </template>
          </rf-nested>
        </rf-form>
      '''
    )
    def('resource', ->
      title: ''
      subtasks: [
        {
          title: ''
          deadline: new Date
        }
      ]
    )

    it "renders nested array", ->
      subtaskTitle = $wrapper.find('.subtask-title')

      subtaskTitle.setData($value: 'Subtask title')

      expect($wrapper.vm.resource.subtasks[0].title).toBe 'Subtask title'

    it "preserializes data", ->
      expect($wrapper.vm.$refs.form.preserialize()).toEqual(
        {
          title: ''
          subtasksAttributes: [
            {
              title: ''
              deadline: $resource.subtasks[0].deadline
            }
          ]
        }
      )
    describe "with errors", ->
      def('errors', ->
        {
          "subtasks[0].title": ["Invalid property"]
        }
      )

      it "renders error for nested entities", ->
        input = $wrapper.vm.$refs.input

        expect(input.$firstError).toBe "Invalid property"

  describe 'one object', ->
    def('template', ->
      '''
        <rf-form :resource="resource">
          <rf-input name="title" />
          <rf-nested name="subtask">
            <template slot-scope="props">
              <rf-input name="title" class="subtask-title" />
              <rf-input name="deadline" />
            </template>
          </rf-nested>
        </rf-form>
      '''
    )
    def('resource', ->
      title: ''
      subtask: {
        title: ''
        deadline: new Date
      }
    )

    it "renders nested object", ->
      subtaskTitle = $wrapper.find('.subtask-title')

      subtaskTitle.setData($value: 'Subtask title')

      expect($wrapper.vm.resource.subtask.title).toBe 'Subtask title'



    