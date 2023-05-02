import './setup'

import {
  mount
} from '@vue/test-utils'
import Vue from 'vue'

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

    describe "with translate function", ->
      def('translate', -> jest.fn((property, modelName) -> property))
      beforeEach ->
        Vue.prototype.VueResourceForm.translate = $translate

        $wrapper.find('.subtask-title').vm.$label
      describe "without translation-name passed", ->
        it 'should pass proper modelName singular', ->
          expect($translate).toHaveBeenCalledWith('title', 'Subtask')

      describe "with translation-name passed", ->
        def('template', ->
          '''
            <rf-form :resource="resource" :errors="errors" ref="form">
              <rf-input name="title" />
              <rf-nested name="subtasks" translation-name="task">
                <template slot-scope="props">
                  <rf-input name="title" class="subtask-title" ref="input" />
                  <rf-input name="deadline" />
                </template>
              </rf-nested>
            </rf-form>
          '''
        )

        it 'should pass proper modelName', ->
          expect($translate).toHaveBeenCalledWith('title', 'task')

    describe "with errors", ->
      def('errors', ->
        {
          "subtasks[0].title": ["Invalid property"]
        }
      )

      it "renders error for nested entities", ->
        input = $wrapper.vm.$refs.input

        expect(input.$firstError).toBe "Invalid property"

    describe "with common errors", ->
      def('errors', ->
        {
          "subtasks.title": ["Invalid property"]
        }
      )

      it "renders error for nested entities", ->
        input = $wrapper.vm.$refs.input

        expect(input.$firstError).toBe "Invalid property"

    describe 'with filtered items', ->
      def('errors', ->
        {
          "subtasks[0].title": ["Invalid property"]
        }
      )

      def('resource', ->
        title: ''
        subtasks: [
          {
            title: '1'
            deadline: new Date
            _destroy: true
          }
          {
            title: '2'
            deadline: new Date
          }
        ]
      )

      it "doesn't render error for non-filtered resource", ->
        input = $wrapper.find('.subtask-title').vm

        expect(input.$firstError).not.toBe "Invalid property"

    describe 'with explicit filter', ->
      def('template', ->
        '''
          <rf-form :resource="resource" :errors="errors" ref="form">
            <rf-input name="title" />
            <rf-nested name="subtasks" :filter="(item) => !item.shouldExclude">
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
            title: 'First'
            deadline: new Date
            shouldExclude: true
          }
          {
            title: 'Second'
            deadline: new Date
          }
        ]
      )

      test "doesnt show filtered item", ->
        input = $wrapper.find('.subtask-title').vm


        expect(input.$value).toBe 'Second'


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
    def('subtaskTitle', -> $wrapper.find('.subtask-title'))


    it "has correct $rootResource", ->
      expect($subtaskTitle.vm.$rootResource).toBe $resource

    it "renders nested object", ->
      $subtaskTitle.setData($value: 'Subtask title')

      expect($wrapper.vm.resource.subtask.title).toBe 'Subtask title'



