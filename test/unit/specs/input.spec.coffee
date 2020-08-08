import {
  shallowMount
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import Vue from 'vue'
import capitalize from '../../../src/utils/capitalize'

Vue.use(Vrf)


describe 'form', ->
  it 'simple input', ->
    wrapper =  mount(
      template: '''
        <rf-form :resource="resource">
          <rf-input name="title" />
        </rf-form>
      '''
      data: ->
        resource:
          title: ''
    )

    input = wrapper.find('input')
    input.setData(value: 'text')
    expect(wrapper.vm.resource.title).toBe 'text'

  it 'input transform', ->
    wrapper =  mount(
      template: '''
        <rf-form :resource="resource">
          <rf-input name="title" :transform="capitalize"/>
        </rf-form>
      '''
      data: ->
        resource:
          title: ''

      methods: {capitalize}
    )

    input = wrapper.find('input')
    input.setData(value: 'text')
    await wrapper.vm.$nextTick()
    expect(wrapper.vm.resource.title).toBe 'Text'