import {
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import Vue from 'vue'

Vue.use(Vrf)

describe 'checkbox', ->
  it "simple checkbox", ->
    wrapper = mount(
      template: '''
        <rf-form :resource="resource">
          <rf-checkbox name="flag" />
        </rf-form>
      '''

      data: ->
        resource:
          flag: true
    )

    checkbox = wrapper.find('input')

    expect(checkbox.vm.checkboxValue).toBe true

    checkbox.setChecked(false)

    expect(wrapper.vm.resource.flag).toBe false

  it "inverted mode", ->
    wrapper = mount(
      template: '''
        <rf-form :resource="resource">
          <rf-checkbox name="flag" inverted />
        </rf-form>
      '''

      data: ->
        resource:
          flag: true
    )

    checkbox = wrapper.find('input')

    expect(checkbox.vm.checkboxValue).toBe false

