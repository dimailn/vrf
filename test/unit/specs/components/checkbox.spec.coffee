import './setup'

import {
  mount
} from '@vue/test-utils'

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

    checkbox = wrapper.findComponent({ name: 'rf-checkbox' })

    expect(checkbox.vm.$value).toBe true

    wrapper.find('input').setChecked(false)

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

    checkbox = wrapper.findComponent({ name: 'rf-checkbox' })

    expect(checkbox.vm.$value).toBe false

