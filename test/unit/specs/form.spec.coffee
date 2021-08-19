import {
  mount
} from '@vue/test-utils'

import Vrf, {mutations} from '../../../src'
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vrf)
Vue.use(Vuex)

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


sharedExamplesFor "successful load", ->
  it 'loads resource and show data in ui', ->
    input = $wrapper.find('input')



    expect(input.vm.$value).toBe 'Test'

describe 'form', ->
  beforeEach ->
    middlewares = [$middleware]

    Vue::VueResourceForm.middlewares = middlewares

    await $wrapper.vm.$nextTick()
    await $wrapper.vm.$nextTick()

  def('save', => jest.fn -> Promise.resolve([true, null]))
  def('loadSources', -> jest.fn -> Promise.resolve({
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
  )
  def('loadSource', -> jest.fn -> Promise.resolve(
    [
      {
        id: 1
        title: 'Category 1'
      }
      {
        id: 2
        title: 'Category 2'
      }
    ]
  ))
  def('executeAction', -> jest.fn -> Promise.resolve({data: 'data', status: 200}))
  def(
    'middleware'
    => class extends Middleware
      save: $save
      loadSources: $loadSources
      loadSource: $loadSource
      executeAction: $executeAction
  )

  def('wrapper', ->
    mount(
      template: '''
        <rf-form name="Todo" auto class="form">
          <rf-input name="title" />
          <rf-submit class="submit" />
        </rf-form>
      '''
    )
  )

  itBehavesLike "successful load"

  describe 'vuex enabled', ->
    def('store', ->
      new Vuex.Store(
        {
          state: {
            todo: null
          }
          mutations
        }
      )
    )
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" auto class="form" vuex>
            <rf-input name="title" />
            <rf-submit class="submit" />
          </rf-form>
        '''
        {store: $store}
      )
    )

    itBehavesLike "successful load"

    it 'puts resource in vuex', ->
      expect($store.state.todo).toBeDefined()
      expect($store.state.todo).toEqual(
        expect.objectContaining(title: 'Test')
      )


  it 'saves resource', ->
    submit = $wrapper.find('.submit')
    submit.trigger('click')

    await $wrapper.vm.$nextTick()

    expect($save.mock.calls.length).toBe(1)

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

  it 'executes action', ->
    form = $wrapper.vm.$children[0]

    {data, status} = await form.executeAction('archive')

    expect(data).toBe 'data'
    expect(status).toBe 200
    expect($executeAction.mock.calls[0][0]).toBe('archive')

  describe 'sources', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="User" auto>
            <rf-select name="role" options="roles" />
            <rf-select name="type" options="types" />
          </rf-form>
        '''
      )
    )

    it 'is loaded eager', ->
      expect($loadSources.mock.calls[0][0]).toEqual(['roles', 'types'])

      formSources = $wrapper.vm.$children[0].$sources

      expect(formSources.roles.length).toBe 2
      expect(formSources.types.length).toBe 1

    it 'requireSource after form initial data loading loads one source through middleware.loadSource', ->
      expect($loadSource.mock.calls.length).toBe 0

      form = $wrapper.vm.$children[0]

      form.requireSource('categories')

      await wrapper.vm.$nextTick()

      expect($loadSource.mock.calls[0][0]).toBe 'categories'
      expect(form.$sources.categories.length).toBe 2




