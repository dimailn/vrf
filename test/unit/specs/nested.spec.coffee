import {
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import Vue from 'vue'

Vue.use(Vrf)

describe 'nested', ->
  it "renders nested array", ->
    wrapper = mount(
      template: '''
        <rf-form :resource="resource">
          <rf-input name="title" />
          <rf-nested name="subtasks">
            <template slot-scope="props">
              <rf-input name="title" class="subtask-title" />
              <rf-input name="deadline" />
            </template>
          </rf-nested>
        </rf-form>
      '''
      data: ->
        resource:
          title: ''
          subtasks: [
            {
              title: ''
              deadline: new Date
            }
          ]
    )

    subtaskTitle = wrapper.find('.subtask-title')

    subtaskTitle.setData($value: 'Subtask title')

    expect(wrapper.vm.resource.subtasks[0].title).toBe 'Subtask title'

  it "renders nested object", ->
    wrapper = mount(
      template: '''
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
      data: ->
        resource:
          title: ''
          subtask: {
            title: ''
            deadline: new Date
          }     
    )

    subtaskTitle = wrapper.find('.subtask-title')

    subtaskTitle.setData($value: 'Subtask title')

    expect(wrapper.vm.resource.subtask.title).toBe 'Subtask title'


  it "renders error for nested entities", ->
    wrapper = mount(
      template: '''
        <rf-form :resource="resource" :errors="errors">
          <rf-input name="title" />
          <rf-nested name="subtasks">
            <template slot-scope="props">
              <rf-input name="title" class="subtask-title" ref="input" />
              <rf-input name="deadline" />
            </template>
          </rf-nested>
        </rf-form>
      '''
      data: ->
        errors: {
          "subtasks[0].title": ["Invalid property"]
        }
        resource:
          title: ''
          subtasks: [
            {
              title: ''
              deadline: new Date
            }
          ]
    )

    input = wrapper.vm.$refs.input

    expect(input.$firstError).toBe "Invalid property"
    