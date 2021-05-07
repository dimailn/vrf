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

describe 'form', ->
  it 'loads resource', ->
    setup(Middleware)

    wrapper = mount(
      template: '''
        <rf-form name="Todo" auto class="form">
          <rf-input name="title" />
          <rf-submit class="submit" />
        </rf-form>
      '''
    )

    input = wrapper.find('input')
    
    await wrapper.vm.$nextTick()
    await wrapper.vm.$nextTick()

    expect(input.vm.$value).toBe 'Test'

  it 'saves resource', ->
    save = jest.fn -> Promise.resolve([true, null])

    middleware = class extends Middleware
      save: save

    setup(middleware)

    wrapper = mount(
      template: '''
        <rf-form name="Todo" auto class="form">
          <rf-input name="title" />
          <rf-submit class="submit" />
        </rf-form>
      '''
    )

    submit = wrapper.find('.submit')
    submit.trigger('click')

    await wrapper.vm.$nextTick()
    
    expect(save.mock.calls.length).toBe(1)

  it 'executes action', ->
    executeAction = jest.fn -> Promise.resolve({data: 'data', status: 200})

    middleware = class extends Middleware
      executeAction: executeAction

    setup(middleware)

    wrapper = mount(
      template: '''
        <rf-form name="Todo" auto class="form">
          <rf-input name="title" />
          <rf-submit class="submit" />
        </rf-form>
      '''
    )

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

  it 'eager load sources', ->
    loadSources = jest.fn -> Promise.resolve({
      roles: [
        {
          id: 'admin'
          title: 'Admin'
        }
        {
          id: 'manager'
          title: 'Manager'
        }
      ],
      types: [
        {
          id: 1,
          title: 'Some type'
        }
      ]
    })

    middleware = class extends Middleware
      loadSources: loadSources

    setup(middleware)

    wrapper = mount(
      template: '''
        <rf-form name="User" auto>
          <rf-select name="role" options="roles" />
          <rf-select name="type" options="types" />
        </rf-form>
      '''
    )

    await wrapper.vm.$nextTick()

    expect(loadSources.mock.calls[0][0]).toEqual(['roles', 'types'])

    formSources = wrapper.vm.$children[0].$sources

    expect(formSources.roles.length).toBe 2
    expect(formSources.types.length).toBe 1

