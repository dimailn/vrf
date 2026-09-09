import './setup'

import {
  mount
} from '@vue/test-utils'

describe 'action-result', ->
  def('statusHandle', -> 'SUCCESSFUL')
  def('result', -> { data: 'payload', status: 200, statusHandle: $statusHandle })

  setResult = (wrapper, name, result) ->
    form = wrapper.findComponent({ name: 'rf-form' }).vm
    form.setActionResult(name, result)
    await wrapper.vm.$nextTick()

  describe 'default slot rendering', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource">
            <rf-action-result name="archive">
              <template #default="{ data, status }">
                <span class="out">{{ data }}:{{ status }}</span>
              </template>
            </rf-action-result>
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
      )
    )

    it 'renders nothing before there is a result', ->
      result = $wrapper.findComponent({ name: 'rf-action-result' })

      expect(result.vm.$result).toBeUndefined()
      expect($wrapper.find('.out').exists()).toBe false

    it 'leaves every status flag undefined before a result', ->
      result = $wrapper.findComponent({ name: 'rf-action-result' }).vm

      expect(result.$isSuccess).toBeUndefined()
      expect(result.$isFailure).toBeUndefined()
      expect(result.$isSoftFailure).toBeUndefined()
      expect(result.$isNetworkFailure).toBeUndefined()
      expect(result.$isServerFailure).toBeUndefined()

    describe 'after a result arrives', ->
      beforeEach ->
        await setResult($wrapper, 'archive', $result)

      it 'exposes the result and computed flags', ->
        result = $wrapper.findComponent({ name: 'rf-action-result' })

        expect(result.vm.$result).toEqual $result
        expect(result.vm.$isSuccess).toBe true
        expect(result.vm.$isFailure).toBe false

      it 'renders the default slot with data and status', ->
        expect($wrapper.find('.out').text()).toBe 'payload:200'

  describe 'named status slots', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource">
            <rf-action-result name="archive">
              <template #success="{ data }"><span class="success">{{ data }}</span></template>
              <template #failure="{ data }"><span class="failure">{{ data }}</span></template>
              <template #soft-failure="{ data }"><span class="soft">{{ data }}</span></template>
              <template #network-failure="{ data }"><span class="net">{{ data }}</span></template>
              <template #server-failure="{ data }"><span class="server">{{ data }}</span></template>
            </rf-action-result>
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
      )
    )

    describe 'successful result', ->
      def('statusHandle', -> 'SUCCESSFUL')
      beforeEach -> await setResult($wrapper, 'archive', $result)

      it 'renders only the success slot', ->
        result = $wrapper.findComponent({ name: 'rf-action-result' })

        expect(result.vm.$isSuccess).toBe true
        expect($wrapper.find('.success').exists()).toBe true
        expect($wrapper.find('.failure').exists()).toBe false

    describe 'soft failure result', ->
      def('statusHandle', -> 'SOFT_FAILURE')
      beforeEach -> await setResult($wrapper, 'archive', $result)

      it 'renders failure and soft-failure slots', ->
        result = $wrapper.findComponent({ name: 'rf-action-result' })

        expect(result.vm.$isSuccess).toBe false
        expect(result.vm.$isFailure).toBe true
        expect(result.vm.$isSoftFailure).toBe true
        expect($wrapper.find('.failure').exists()).toBe true
        expect($wrapper.find('.soft').exists()).toBe true
        expect($wrapper.find('.success').exists()).toBe false

    describe 'network failure result', ->
      def('statusHandle', -> 'NETWORK_FAILURE')
      beforeEach -> await setResult($wrapper, 'archive', $result)

      it 'renders the network-failure slot', ->
        result = $wrapper.findComponent({ name: 'rf-action-result' })

        expect(result.vm.$isNetworkFailure).toBe true
        expect($wrapper.find('.net').exists()).toBe true

    describe 'server failure result', ->
      def('statusHandle', -> 'SERVER_FAILURE')
      beforeEach -> await setResult($wrapper, 'archive', $result)

      it 'renders the server-failure slot', ->
        result = $wrapper.findComponent({ name: 'rf-action-result' })

        expect(result.vm.$isServerFailure).toBe true
        expect($wrapper.find('.server').exists()).toBe true

  describe 'with a component prop', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form name="Todo" :resource="resource">
            <rf-action-result name="archive" :component="component" />
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
          component:
            name: 'result-view'
            props: ['data', 'status']
            template: '<div class="component-out">{{ data }} - {{ status }}</div>'
      )
    )

    beforeEach -> await setResult($wrapper, 'archive', $result)

    it 'renders the given component with data and status', ->
      out = $wrapper.find('.component-out')

      expect(out.exists()).toBe true
      expect(out.text()).toBe 'payload - 200'
