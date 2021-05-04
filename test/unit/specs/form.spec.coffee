import {
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import Vue from 'vue'

Vue.use(Vrf)

wrapper = null

class Middleware
  @accepts: -> true
  constructor: (@name, @form) ->

  load: ->
    Promise.resolve({title: 'Test'})

  loadSources: ->
    Promise.resolve({})
  save: ->
    Promise.resolve()
    
setup = (middleware) ->
    middlewares = [middleware]

    Vue::VueResourceForm.middlewares = middlewares

    wrapper = mount(
      template: '''
        <rf-form name="Todo" auto class="form">
          <rf-input name="title" />
          <rf-submit class="submit" />
        </rf-form>
      '''
    )
describe 'form', ->
  it 'loads resource', ->
    setup(Middleware)

    input = wrapper.find('input')
    
    await wrapper.vm.$nextTick()
    await wrapper.vm.$nextTick()

    expect(input.vm.$value).toBe 'Test'

  it 'saves resource', ->
    save = jest.fn -> Promise.resolve([true, null])

    middleware = class extends Middleware
      save: save

    setup(middleware)

    submit = wrapper.find('.submit')
    submit.trigger('click')

    await wrapper.vm.$nextTick()
    
    expect(save.mock.calls.length).toBe(1)

  it 'executes action', ->
    executeAction = jest.fn -> Promise.resolve({data: 'data', status: 200})

    middleware = class extends Middleware
      executeAction: executeAction

    setup(middleware)

    form = wrapper.vm.$children[0]

    {data, status} = await form.executeAction('archive')

    expect(data).toBe 'data'
    expect(status).toBe 200
    expect(executeAction.mock.calls[0][0]).toBe('archive')

  it 'disabled all inputs', ->
    wrapper = mount(
      template: '''
        <rf-form :resource="resource" disabled="$resource.disabled">
          <rf-input name="title" />
        </rf-form>
      '''

      data: ->
        resource:
          title: ''
          disabled: true
    )

    input = wrapper.find('input')
    expect(input.attributes('disabled')).toBe 'disabled'


