import './setup'

import {
  mount
} from '@vue/test-utils'

import { config } from '@vue/test-utils'

describe 'action', ->
  def('executeAction', -> jest.fn -> Promise.resolve({ data: 'ok', status: 200, statusHandle: 'SUCCESSFUL' }))
  def('reloadOnResult', -> false)

  def('effects', ->
    [
      {
        name: 'rest'
        api: true
        effect: ({ onExecuteAction }) ->
          onExecuteAction($executeAction)
      }
    ]
  )

  beforeEach ->
    config.global.config ||= {}
    config.global.config.globalProperties ||= {}
    config.global.config.globalProperties.VueResourceForm ||= {}
    config.global.config.globalProperties.VueResourceForm.effects = $effects

  afterEach ->
    config.global.config.globalProperties.VueResourceForm.effects = null

  describe 'default button rendering', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource" :effects="['rest']">
            <rf-action name="archive" class="rf-action" :reload-on-result="reloadOnResult" @result="onResult" />
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
          reloadOnResult: $reloadOnResult
        methods:
          onResult: $onResult
      )
    )
    def('onResult', -> jest.fn())

    it 'renders a button with the label', ->
      button = $wrapper.find('button')

      expect(button.exists()).toBe true
      expect(button.text()).toBe 'archive'

    it 'exposes $label from the name', ->
      action = $wrapper.findComponent({ name: 'rf-action' })

      expect(action.vm.$label).toBe 'archive'

    it 'executes the action on click', ->
      await $wrapper.find('.rf-action').trigger('click')

      expect($executeAction.mock.calls[0][0]).toBe 'archive'

    it 'emits the result after execution', ->
      action = $wrapper.findComponent({ name: 'rf-action' })

      await action.vm.onClick()
      await $wrapper.vm.$nextTick()

      expect($onResult).toHaveBeenCalled()
      result = $onResult.mock.calls[0][0]
      expect(result.data).toBe 'ok'
      expect(result.status).toBe 200

    describe 'with reload-on-result', ->
      def('reloadOnResult', -> true)

      it 'reloads the resource after result', ->
        action = $wrapper.findComponent({ name: 'rf-action' })
        # Spy on the exact $form reference the action calls into.
        reloadSpy = jest.spyOn(action.vm.$form, 'reloadResource').mockImplementation()

        await action.vm.onClick()

        expect(reloadSpy).toHaveBeenCalled()

  describe 'with explicit label', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource" :effects="['rest']">
            <rf-action name="archive" label="Archive it" />
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
      )
    )

    it 'uses the label prop', ->
      action = $wrapper.findComponent({ name: 'rf-action' })

      expect(action.vm.$label).toBe 'Archive it'
      expect($wrapper.find('button').text()).toBe 'Archive it'

  describe 'passing request options', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource" :effects="['rest']">
            <rf-action
              name="archive"
              :params="params"
              :data="data"
              method="put"
              url="/custom"
            />
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
          params: { a: 1 }
          data: { b: 2 }
      )
    )

    it 'forwards params, data, method and url to executeAction', ->
      action = $wrapper.findComponent({ name: 'rf-action' })
      await action.vm.onClick()

      [name, options] = $executeAction.mock.calls[0]

      expect(name).toBe 'archive'
      expect(options.params).toEqual { a: 1 }
      expect(options.data).toEqual { b: 2 }
      expect(options.method).toBe 'put'
      expect(options.url).toBe '/custom'

  describe 'with a single-node activator slot', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource" :effects="['rest']">
            <rf-action name="archive">
              <template #activator="{ on, label, humanName, pending }">
                <a class="activator" @click="on.onClick">{{ label }}/{{ humanName }}/{{ pending }}</a>
              </template>
            </rf-action>
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
      )
    )

    it 'renders the activator slot with scope', ->
      activator = $wrapper.find('.activator')

      expect(activator.exists()).toBe true
      expect(activator.text()).toBe 'archive/archive/false'
      expect($wrapper.find('button').exists()).toBe false

    it 'executes the action from the activator', ->
      await $wrapper.find('.activator').trigger('click')

      expect($executeAction.mock.calls[0][0]).toBe 'archive'

  describe 'with a multi-node activator slot', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource" :effects="['rest']">
            <rf-action name="archive">
              <template #activator="{ on }">
                <a class="activator" v-on="on">Go</a>
                <span class="hint">hint</span>
              </template>
            </rf-action>
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
      )
    )

    it 'wraps multiple nodes in a div', ->
      action = $wrapper.findComponent({ name: 'rf-action' })

      expect(action.find('div').exists()).toBe true
      expect($wrapper.find('.activator').exists()).toBe true
      expect($wrapper.find('.hint').exists()).toBe true

  describe 'humanName deprecation', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource" :effects="['rest']">
            <rf-action name="archive" />
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
      )
    )

    it 'warns and returns $label', ->
      warnSpy = jest.spyOn(console, 'warn').mockImplementation()
      action = $wrapper.findComponent({ name: 'rf-action' })

      expect(action.vm.humanName).toBe 'archive'
      expect(warnSpy).toHaveBeenCalledWith('[vrf] Computed property humanName is deprecated, use $label instead')

      warnSpy.mockRestore()
