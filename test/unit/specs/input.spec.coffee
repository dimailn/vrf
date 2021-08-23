import {
  shallowMount
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import Vue from 'vue'
import capitalize from '../../../src/utils/capitalize'

Vue.use(Vrf)


describe 'form', ->
  def('data', ->
    resource:
      title: ''
  )
  def('template', ->
    '''
      <rf-form :resource="resource">
        <rf-input name="title" />
      </rf-form>
    '''
  )
  def('wrapper', ->
    mount(
      template: $template
      data: -> $data
    )
  )
  def('capitalize', -> jest.fn capitalize)
  def('input', -> $wrapper.find('input'))

  it 'simple input', ->
    $input.setData($value: 'text')
    expect($wrapper.vm.resource.title).toBe 'text'

  describe 'with transform', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-input name="title" :transform="capitalize"/>
          </rf-form>
        '''
        data: -> $data

        methods: {capitalize: $capitalize}
      )
    )

    it 'input transform', ->
      $input.setData($value: 'text')
      await $wrapper.vm.$nextTick()
      expect($wrapper.vm.resource.title).toBe 'Text'
      expect($capitalize.mock.calls.length).toBe 1

    describe 'when title is undefined', ->
      it "doesn't call transform" , ->
        $input.setData($value: undefined)

        await $wrapper.vm.$nextTick() 

        expect($capitalize.mock.calls.length).toBe 0

