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
  describe 'auto mode, after load', ->
    beforeEach ->
      Vue::VueResourceForm.effects = $effects
      Vue::VueResourceForm.idFromRoute = $idFromRoute

    def('idFromRoute', -> -> 1)
    def('save', => jest.fn -> Promise.resolve([true, null]))
    def('sources', ->
      {
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
        categories: [
          {
            id: 1
            title: 'Category 1'
          }
          {
            id: 2
            title: 'Category 2'
          }
        ]
      }
    )
    def('loadSources', -> jest.fn (names) ->
      Promise.resolve(
        Object.entries($sources)
          .filter(([name, options]) -> names.includes(name))
          .reduce(
            (sources, [name, options]) -> sources[name] = options; sources
            {}
          )
      )
    )
    def('loadSource', (name) -> jest.fn (name) -> Promise.resolve($sources[name]))

    def('load', -> jest.fn -> Promise.resolve({id: 1, title: 'Test'}))
    def('executeAction', -> jest.fn -> Promise.resolve({data: 'data', status: 200}))



    def('create', -> jest.fn -> ->)
    def('update', -> jest.fn -> ->)
    def('created', -> jest.fn -> ->)
    def('validate', -> jest.fn -> true)
    def('loadFailure', -> jest.fn -> ->)
    def('listeners', -> {})

    def('effects', ->
      [
        {
          name: 'rest',
          api: true,
          effect: ({
            onLoad
            onLoadSources
            onLoadSource
            onSave
            onExecuteAction
            onCreate
            onCreated
            onUpdate
            onValidate
            onLoadFailure
          }) ->
            onCreate($create)
            onUpdate($update)
            onSave($save)
            onLoadSource($loadSource)
            onLoadSources($loadSources)
            onLoad($load)
            onExecuteAction($executeAction)
            onCreated($created)
            onValidate($validate)
            onLoadFailure($loadFailure)
        }
      ]
    )



    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" auto class="form" v-on="listeners">
            <rf-input name="title" />
            <rf-submit class="submit" />
            <rf-action name="archive" class="rf-action" />
          </rf-form>
        '''
        computed:
          listeners: -> $listeners
      )
    )

    describe 'load failure', ->
      def('listeners', -> {
        'after-load-failure': jest.fn()
      })

      beforeEach ->
        $load.mockImplementation(-> Promise.reject())

        await $wrapper.vm.$nextTick()
        await $wrapper.vm.$nextTick()

      test 'emits events', ->
        expect($loadFailure).toHaveBeenCalled()
        expect($listeners['after-load-failure']).toHaveBeenCalled()

    describe 'after ticks', ->
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

        itBehavesLike "successful data showing"

        it 'puts resource in vuex', ->
          expect($store.state.todo).toBeDefined()
          expect($store.state.todo).toEqual(
            expect.objectContaining(title: 'Test')
          )


      describe 'submit click', ->
        beforeEach ->
          submit = $wrapper.find('.submit')
          submit.trigger('click')

          await $wrapper.vm.$nextTick()

        it 'saves resource', ->
          expect($save.mock.calls.length).toBe(1)

        describe 'with onValidate', ->
          def('validate', -> jest.fn -> false)

          it 'doesnt save resource', ->
            expect($save.mock.calls.length).toBe(0)


        describe 'no onSave', ->
          def('save', -> null)
          def('create', -> jest.fn -> Promise.resolve([true, 1]))
          def('update', -> jest.fn -> Promise.resolve([true, null]))


          describe 'onUpdate', ->
            def('idFromRoute', -> -> 1)

            it "updates", ->
              expect($load.mock.calls.length).toBe 1 # data loading
              expect($update.mock.calls.length).toBe(1)
              expect($create.mock.calls.length).toBe(0)

          describe 'onCreate without onCreated capture', ->
            def('idFromRoute', -> -> null)

            it "creates", ->
              expect($load.mock.calls.length).toBe 1 # loading after create
              expect($update.mock.calls.length).toBe(0)
              expect($create.mock.calls.length).toBe(1)

          describe "onCreate with onCreated capture", ->
            def('idFromRoute', -> -> null)
            def('created', -> jest.fn (e) ->  e.stopPropagation())

            it "creates and doesn't reload", ->
              expect($load.mock.calls.length).toBe 0
              expect($update.mock.calls.length).toBe(0)
              expect($create.mock.calls.length).toBe(1)



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
              <rf-form :resource="resource" :disabled="disabled">
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

        it 'requireSource after form initial data loading loads one source through effect.loadSource', ->
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

          beforeEach ->
            $wrapper.vm.options = 'types'

          it 'contains types', ->
            expect($select.vm.$_options).toEqual(
              [
                {
                  id: 1,
                  title: 'Some type'
                }
              ]
            )

        describe 'rf-require', ->
          describe 'static', ->
            def('wrapper', ->
              mount(
                template: '''
                  <rf-form name="User" auto>
                    <rf-require name="roles" />
                    <rf-require name="types" />
                  </rf-form>
                '''
              )
            )

            it 'is loaded eager', ->
              expect($loadSources.mock.calls[0][0]).toEqual(['roles', 'types'])

              formSources = $wrapper.vm.$children[0].$sources
              expect(formSources.roles.length).toBe 2
              expect(formSources.types.length).toBe 1

          describe 'dynamic', ->
            def('wrapper', ->
              mount(
                template: '''
                  <rf-form name="User" auto>
                    <rf-require :name="name" />
                  </rf-form>
                '''
                data: ->
                  name: 'roles'
              )
            )

            beforeEach ->
              $wrapper.vm.name = 'types'

            it 'invokes loadSource after loadSources', ->
              expect($loadSources.mock.calls[0][0]).toEqual(['roles'])
              expect($loadSource.mock.calls[0][0]).toEqual('types')

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

    describe 'side effects', ->
      def('effects', -> [
        {
          name: 'test1',
          effect: jest.fn()
        },
        {
          name: 'test2',
          effect: jest.fn()
        },
        {
          name: 'test3',
          effect: jest.fn()
        }
      ])

      beforeEach ->
          Vue::VueResourceForm.effects = $effects
          await $wrapper.vm.$nextTick()


      describe 'effects === true', ->
        def('wrapper', ->
          mount(
            template: '''
              <rf-form effects/>
            '''
          )
        )

        test 'activates all effects', ->
          expect($effects[0].effect).toHaveBeenCalled()
          expect($effects[1].effect).toHaveBeenCalled()
          expect($effects[2].effect).toHaveBeenCalled()


      describe 'choose some effects', ->
        def('wrapper', ->
          mount(
            template: '''
              <rf-form :effects="['test2', 'test3']" />
            '''
          )
        )

        test 'activates two effects', ->
          expect($effects[0].effect).not.toHaveBeenCalled()
          expect($effects[1].effect).toHaveBeenCalled()
          expect($effects[2].effect).toHaveBeenCalled()

      describe 'pass effect implementation and strings mixed', ->
        def('additionalEffect', -> {
          name: 'test4',
          effect: jest.fn()
        })

        def('wrapper', ->
          mount(
            template: '''
              <rf-form :effects="['test2', effect]" />
            '''
            computed:
              effect: -> $additionalEffect
          )
        )

        test 'activates chosen effect and directly passed implementation', ->
          expect($effects[0].effect).not.toHaveBeenCalled()
          expect($effects[1].effect).toHaveBeenCalled()
          expect($effects[2].effect).not.toHaveBeenCalled()
          expect($additionalEffect.effect).toHaveBeenCalled()

      describe 'when effects changes', ->
        def('test1Unmounted', -> jest.fn())
        def('test2Mounted', -> jest.fn())
        def('effects', -> [
          {
            name: 'test1',
            effect: jest.fn(({onUnmounted}) -> onUnmounted($test1Unmounted))
          },
          {
            name: 'test2',
            effect: jest.fn(({onMounted}) -> onMounted($test2Mounted))
          }
        ])

        def('wrapper', ->
          mount(
            template: '''
              <rf-form :effects="effects" />
            '''

            data: ->
              effects: ['test1']
          )
        )

        beforeEach ->
          $wrapper.vm.effects = ['test2']
          await $wrapper.vm.$nextTick()

        test 'remounts effects', ->
          expect($test1Unmounted).toHaveBeenCalled()
          expect($test2Mounted).toHaveBeenCalled()




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

      def('warnSpy', -> jest.spyOn(console, 'warn'))

      describe "reloadResource", ->
        beforeEach ->
          $warnSpy.mockImplementation()
          $wrapper.vm.$refs.form.reloadResource()

        afterEach ->
          $warnSpy.mockRestore()

        itBehavesLike "non-auto mode warnings"

      describe "reloadSources", ->
        beforeEach ->
          $warnSpy.mockImplementation()
          $wrapper.vm.$refs.form.reloadSources()
        afterEach ->
          $warnSpy.mockRestore()

        itBehavesLike "non-auto mode warnings"