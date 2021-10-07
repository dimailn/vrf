import './setup'

import {
  shallowMount
  mount
} from '@vue/test-utils'

import capitalize from '../../../../src/utils/capitalize'
import Vuex from 'vuex'
import {mutations} from '../../../../src'
import Vue from 'vue'

Vue.use(Vuex)

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

  describe 'state in form', ->
    it 'simple input', ->
      $input.setData($value: 'text')
      expect($wrapper.vm.resource.title).toBe 'text'

  describe 'state in vuex', ->
    def('template', ->
      '''
        <rf-form name="Todo" :resource.sync="resource" vuex>
          <rf-input name="title" />
        </rf-form>
      '''
    )
    def('store', ->
      new Vuex.Store(
        {
          state: {
            todo: {title: ''}
          }
          mutations
        }
      )
    )
    def('wrapper', ->
      mount(
        {
          template: $template
          data: ->
            resource: null
        }
        {store: $store}
      )
    )
    beforeEach -> $input.setData($value: 'text')

    it 'state changes', -> 
      expect($wrapper.vm.resource.title).toBe 'text'
      expect($store.state.todo.title).toBe 'text'

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

  describe "input for value without field in resource", ->
    def('watchTitle', -> jest.fn())
    def('wrapper', ->
      mount(
        template: $template
        data: -> {
          resource: {}
        }
        watch:
          'resource.title': $watchTitle
      )
    )

    beforeEach ->
      $input.setValue("Test")


    it "calls watcher", ->
      expect($watchTitle).toHaveBeenCalled()


