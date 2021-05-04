import {
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import Vue from 'vue'

Vue.use(Vrf)

describe 'checkbox', ->
  it "simple bitwise", ->
    wrapper = mount(
      template: '''
        <rf-form :resource="resource">
          <rf-bitwise name="flags" :options="options" ref="bitwise" />
        </rf-form>
      '''

      data: ->
        options: [
            {
                id: 0
                title: 'User'
            }
            {
                id: 1
                name: 'Manager'
            }
            {
                id: 2
                name: 'Admin'
            }
        ]
        resource:
          flags: 0
    )

    checkboxes = wrapper.findAll('input[type="checkbox"]')

    checkboxes.at(2).setChecked(true)
    checkboxes.at(1).setChecked(true)

    await wrapper.vm.$nextTick()

    expect(wrapper.vm.resource.flags).toBe 6


