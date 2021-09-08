import './setup'

import {
  mount
} from '@vue/test-utils'

import {mutations} from '../../../../src'

import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)


sharedExamplesFor "successful data showing", ->
  it 'show data in ui', ->
    input = $wrapper.find('input')

    expect(input.vm.$value).toBe 'Test'

sharedExamplesFor "non-auto mode warnings", ->
  it "warns", ->
    expect($warnSpy).toHaveBeenCalledWith("Reload methods is applicable only to auto-forms")

describe 'form', ->
  beforeEach ->
    middlewares = [$middleware]

    Vue::VueResourceForm.middlewares = middlewares

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
  def('load', -> jest.fn -> Promise.resolve({title: 'Test'}))
  def('executeAction', -> jest.fn -> Promise.resolve({data: 'data', status: 200}))
  def('middleware', -> class Middleware
    constructor: (@name, @form) ->
    @accepts: -> true
    save: $save
    loadSources: $loadSources
    loadSource: $loadSource
    executeAction: $executeAction
    load: $load
  )

  def('wrapper', ->
    mount(
      template: '''
        <rf-form name="Todo" auto class="form">
          <rf-input name="title" />
          <rf-submit class="submit" />
          <rf-action name="archive" class="rf-action" />
        </rf-form>
      '''
    )
  )

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

  describe 'auto mode, after load', ->
    beforeEach ->
      await $wrapper.vm.$nextTick()
      await $wrapper.vm.$nextTick()

    itBehavesLike "successful data showing"

    describe 'nested form ', ->
      def('wrapper', ->
        mount(
          template: '''
            <rf-form name="Todo" auto class="form">
              <rf-input name="title" class="input" />
              <rf-nested name="attrs">
                <template v-slot="props">
                  <rf-input name="status" class="statusInput" />
                  <rf-input name="number" class="numberInput" />
                  <rf-select name="role" options="roles" class="roleInput" />
                </template>
              </rf-nested>
            </rf-form>
          '''
        )
      )

      def('load', -> jest.fn -> Promise.resolve(
        {
          title: 'Test'
          attrs:
            status: 'readonly'
            number: 1
        }
      ))

      def('input', -> $wrapper.find(".input"))
      def('numberInput', -> $wrapper.find(".numberInput"))
      def('statusInput', -> $wrapper.find(".statusInput"))
      def('roleInput', -> $wrapper.find(".roleInput"))

      describe "resource changed on backend", ->
        beforeEach ->
          $load.mockImplementation(-> Promise.resolve(
            {
              title: 'Test2'
              attrs:
                status: 'write'
                number: 2
            }
          ))

        describe "reloadResource()", ->
          beforeEach -> $numberInput.vm.$form.reloadResource()

          it 'reloads only child', ->
            expect($numberInput.vm.$value).toBe 2
            expect($statusInput.vm.$value).toBe "write"
            expect($input.vm.$value).toBe "Test"

        describe "reloadResource resource with current fields", ->
          beforeEach -> $numberInput.vm.$form.reloadResource(['status'])

          it 'reloads only child field', ->
            expect($numberInput.vm.$value).toBe 1
            expect($statusInput.vm.$value).toBe "write"
            expect($input.vm.$value).toBe "Test"
      describe "sources changed on backend", ->
        beforeEach ->
          $loadSources.mockImplementation(-> Promise.resolve(
            {
              roles: [
                {
                  id: 'admin'
                  title: 'Admin'
                }
              ]
            }
          ))

        describe "reloadSources()", ->
          beforeEach -> 
            $numberInput.vm.$form.reloadSources()
            $wrapper.vm.$nextTick()

          it 'reloads sources', ->
            expect($roleInput.vm.$_options).toEqual(
              [
                {
                  id: 'admin'
                  title: 'Admin'
                }
              ]
            )

        

    describe 'vuex enabled', ->
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

      itBehavesLike "successful data showing"

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

    it 'executes action', ->
      form = $wrapper.vm.$children[0]

      {data, status} = await form.executeAction('archive')

      expect(data).toBe 'data'
      expect(status).toBe 200
      expect($executeAction.mock.calls[0][0]).toBe('archive')

    it 'executes action through rf-action', ->
      rfAction = $wrapper.find('.rf-action')
      rfAction.trigger('click')

      expect($executeAction.mock.calls[0][0]).toBe('archive')


    describe 'form disabled', ->
      def('wrapper', ->
        mount(
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
      )

      it 'disables all inputs', ->
        input = $wrapper.find('input')
        expect(input.attributes('disabled')).toBe 'disabled'

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

        await $wrapper.vm.$nextTick()

        expect($loadSource.mock.calls[0][0]).toBe 'categories'
        expect(form.$sources.categories.length).toBe 2

      describe 'change options in runtime', ->
        def('wrapper', ->
          mount(
            template: '''
              <rf-form name="User" auto>
                <rf-select name="entityId" :options="options" />
              </rf-form>
            '''
            data: ->
              options: 'roles'
          )
        )
        def('select', -> $wrapper.find("select"))

        beforeEach -> $wrapper.vm.options = 'types'

        it 'contains types', ->
          expect($select.vm.$_options).toEqual(
            [
              {
                id: 1,
                title: 'Some type'
              }
            ]
          )

    describe 'vuex mode', ->
      def('store', ->
        new Vuex.Store(
          {
            state: {
              todo: {
                title: 'Test'
              }
            }
            mutations
          }
        )
      )
      def('wrapper', ->
        mount(
          template: '''
            <rf-form name="Todo" :resource.sync="resource" auto class="form" vuex>
              <rf-input name="title" />
              <rf-submit class="submit" />
            </rf-form>
          '''
          data: ->
            resource: null
          {store: $store}
        )
      )

      itBehavesLike "successful data showing"

      it "syncs resource from vuex", ->
        await $wrapper.vm.$nextTick()

        expect($wrapper.vm.resource).not.toBeNull()
        expect($wrapper.vm.resource.title).toBe 'Test'


  describe 'non-auto mode', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form class="form" ref="form">
            <rf-input name="title" />
            <rf-submit class="submit" />
          </rf-form>
        '''
      )
    )

    def('warnSpy', -> jest.spyOn console, 'warn')

    describe "reloadResource", ->
      beforeEach -> 
        $warnSpy
        $wrapper.vm.$refs.form.reloadResource()

      itBehavesLike "non-auto mode warnings"

    describe "reloadSources", ->
      beforeEach -> 
        $warnSpy
        $wrapper.vm.$refs.form.reloadSources()

      itBehavesLike "non-auto mode warnings"