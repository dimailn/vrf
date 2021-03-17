import {
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import Vue from 'vue'

Vue.use(Vrf)

describe 'nested', ->
  it "simple nested binding", ->
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

    subtaskTitle.setData(value: 'Subtask title')

    expect(wrapper.vm.resource.subtasks[0].title).toBe 'Subtask title'

