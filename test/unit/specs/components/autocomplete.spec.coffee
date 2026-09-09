import './setup'

import {
  mount
} from '@vue/test-utils'

import { config } from '@vue/test-utils'

describe 'autocomplete', ->
  originalAddEventListener = null

  beforeEach ->
    originalAddEventListener = document.addEventListener
    config.global.config ||= {}
    config.global.config.globalProperties ||= {}
    config.global.config.globalProperties.VueResourceForm ||= {}
    config.global.config.globalProperties.VueResourceForm.autocompletes = $autocompletes

  afterEach ->
    document.addEventListener = originalAddEventListener
    config.global.config.globalProperties.VueResourceForm.templates = {}

  def('autocompletes', => [])

  describe 'with provider', ->
    describe 'with specified title-key', ->
      def('listenersMap', -> {})

      beforeEach ->
        document.addEventListener = jest.fn((event, cb) =>
          $listenersMap[event] = cb
        )

      def('componentOnSelect', -> jest.fn())
      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
                @select="onSelect"
              />
            </rf-form>
          """
          data: ->
            resource: {
              title: ''
            }
          methods:
            onSelect: $componentOnSelect
        )
      )

      def('onLoad', => jest.fn -> Promise.resolve([
        {
          id: 1
          title: 'Some text'
        }
      ]))

      def('onMounted', -> jest.fn())

      def('onSelect', -> jest.fn())

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad, onMounted, onSelect}) ->
            onLoad($onLoad)
            onMounted($onMounted)
            onSelect($onSelect)
        }
      ])

      def('autocomplete', -> $wrapper.find('.autocomplete'))

      def('input', -> $wrapper.find('input'))

      beforeEach -> $wrapper

      test 'calls onMounted', ->
        expect($onMounted).toHaveBeenCalled()

      describe 'on user input autocomplete', ->
        beforeEach ->
          $input.element.value = 'test'
          $input.trigger('input')
          await new Promise((resolve) => setTimeout(resolve, 1000))

        test 'calls onLoad with query', ->
          expect($onLoad).toHaveBeenCalledWith({
            query: 'test',
            entity: 'todo',
            limit: undefined
          })

        test 'contains items', ->
          expect($wrapper.vm.$refs.autocomplete.items).toEqual(
            [
              {
                id: 1
                title: 'Some text'
              }
            ]
          )

        test 'shows suggestion', ->
          expect($wrapper.text()).toContain('Some text')

        describe 'on item clicked', ->
          beforeEach ->
            $wrapper.find('li').trigger('click')

          test 'calls onSelect in provider', ->
            expect($onSelect).toHaveBeenCalledWith(id: 1, title: 'Some text')

          test 'calls onSelect in component', ->
            expect($componentOnSelect).toHaveBeenCalledWith(id: 1, title: 'Some text')

        describe 'on document clicked', ->
          beforeEach ->
            $listenersMap.click(target: $wrapper.find('form').element)

          test 'doesnt show suggestion', ->
            expect($wrapper.text()).not.toContain('Some text')

        describe 'on document clicked inside root', ->
          beforeEach ->
            $listenersMap.click(target: $wrapper.vm.$refs.autocomplete.$refs.root)

          test 'keeps suggestion', ->
            expect($wrapper.text()).toContain('Some text')

        describe 'on input clicked', ->
          beforeEach ->
            $wrapper.vm.$refs.autocomplete.menu = false
            await $wrapper.vm.$nextTick()
            $input.trigger('click')
            await $wrapper.vm.$nextTick()

          test 'reopens the menu', ->
            expect($wrapper.vm.$refs.autocomplete.menu).toBe(true)
            expect($wrapper.text()).toContain('Some text')

        describe 'on item selected sets query and value via title-key', ->
          beforeEach ->
            $wrapper.find('li').trigger('click')
            await $wrapper.vm.$nextTick()

          test 'sets query from title-key', ->
            expect($wrapper.vm.$refs.autocomplete.query).toBe('Some text')

          test 'closes the menu', ->
            expect($wrapper.vm.$refs.autocomplete.menu).toBe(false)

        describe 'presents item with title-key', ->
          test 'shows resolved title', ->
            expect($wrapper.text()).toContain('Some text')

      describe 'without user input query', ->
        beforeEach ->
          $input.element.value = ''
          $input.trigger('input')
          await new Promise((resolve) => setTimeout(resolve, 1000))
          await $wrapper.vm.$nextTick()

        test 'does not call onLoad', ->
          expect($onLoad).not.toHaveBeenCalled()

        test 'has no items', ->
          expect($wrapper.vm.$refs.autocomplete.items).toEqual([])
          expect($wrapper.vm.$refs.autocomplete.menu).toBe(false)

    describe 'with empty results', ->
      def('listenersMap', -> {})

      beforeEach ->
        document.addEventListener = jest.fn((event, cb) =>
          $listenersMap[event] = cb
        )

      def('onLoad', => jest.fn -> Promise.resolve([]))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad}) ->
            onLoad($onLoad)
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'keeps menu closed on empty results', ->
        expect($wrapper.vm.$refs.autocomplete.items).toEqual([])
        expect($wrapper.vm.$refs.autocomplete.menu).toBe(false)

    describe 'with idKey, queryKey and provider onSelect override', ->
      def('listenersMap', -> {})

      beforeEach ->
        document.addEventListener = jest.fn((event, cb) =>
          $listenersMap[event] = cb
        )

      def('onLoad', => jest.fn -> Promise.resolve([
        { id: 42, title: 'Named', code: 'code-42' }
      ]))

      def('providerOnSelect', -> jest.fn())

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad, onSelect, onInput, onValueChanged, onClear}) ->
            onLoad($onLoad)
            onSelect($providerOnSelect)
            onInput(-> undefined)
            onValueChanged(-> undefined)
            onClear(-> undefined)
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                id-key="id"
                query-key="title"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      describe 'on item selected', ->
        beforeEach ->
          $wrapper.find('li').trigger('click')
          await $wrapper.vm.$nextTick()

        test 'sets value from id-key', ->
          expect($wrapper.vm.$refs.autocomplete.$value).toBe(42)

        test 'sets query from query-key', ->
          expect($wrapper.vm.$refs.autocomplete.query).toBe('Named')

      describe 'onValueChanged watcher', ->
        beforeEach ->
          $wrapper.vm.$refs.autocomplete.$value = 100
          await $wrapper.vm.$nextTick()

        test 'is triggered on value change', ->
          expect($wrapper.vm.$refs.autocomplete.$value).toBe(100)

      describe 'on clear', ->
        beforeEach ->
          $wrapper.vm.$refs.autocomplete.onClear()
          await $wrapper.vm.$nextTick()

        test 'resets query and value', ->
          expect($wrapper.vm.$refs.autocomplete.query).toBe('')
          expect($wrapper.vm.$refs.autocomplete.$value).toBe(null)

      describe 'on reset', ->
        beforeEach ->
          $wrapper.vm.$refs.autocomplete.reset()
          await $wrapper.vm.$nextTick()

        test 'resets query and value', ->
          expect($wrapper.vm.$refs.autocomplete.query).toBe('')
          expect($wrapper.vm.$refs.autocomplete.$value).toBe(null)

    describe 'with provider onSelect returning result object', ->
      def('onLoad', => jest.fn -> Promise.resolve([
        { name: 'Alpha' }
      ]))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad, onSelect}) ->
            onLoad($onLoad)
            onSelect((item) -> { value: 'custom-value', query: 'custom-query' })
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                title-key="name"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()
        $wrapper.find('li').trigger('click')
        await $wrapper.vm.$nextTick()

      test 'uses value and query from result object', ->
        expect($wrapper.vm.$refs.autocomplete.$value).toBe('custom-value')
        expect($wrapper.vm.$refs.autocomplete.query).toBe('custom-query')

    describe 'with function-type provider and function title-key', ->
      def('onLoad', => jest.fn -> Promise.resolve([
        { deep: { name: 'Deep name' } }
      ]))

      def('provider', () => ({onLoad}) -> onLoad($onLoad))

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                :type="type"
                entity="todo"
                :title-key="titleKey"
                :id-key="idKey"
                :query-key="queryKey"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
            type: $provider
            titleKey: (item) -> item.deep.name
            idKey: (item) -> item.deep.name
            queryKey: (item) -> item.deep.name
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'presents item using function title-key', ->
        expect($wrapper.text()).toContain('Deep name')

      describe 'on select', ->
        beforeEach ->
          $wrapper.find('li').trigger('click')
          await $wrapper.vm.$nextTick()

        test 'resolves value and query with function keys', ->
          expect($wrapper.vm.$refs.autocomplete.$value).toBe('Deep name')
          expect($wrapper.vm.$refs.autocomplete.query).toBe('Deep name')

    describe 'with object-type provider having setup', ->
      def('onLoad', => jest.fn -> Promise.resolve([
        { title: 'From object provider' }
      ]))

      def('provider', () => { setup: ({onLoad}) -> onLoad($onLoad) })

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                :type="type"
                entity="todo"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
            type: $provider
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'loads items using object provider setup', ->
        expect($wrapper.text()).toContain('From object provider')

    describe 'without title-key presents raw item', ->
      def('onLoad', => jest.fn -> Promise.resolve(['Plain string item']))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad}) -> onLoad($onLoad)
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'renders the plain item', ->
        expect($wrapper.text()).toContain('Plain string item')

    describe 'with allowEmptyRequests', ->
      def('onLoad', => jest.fn -> Promise.resolve([{ title: 'Empty allowed' }]))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad}) -> onLoad($onLoad)
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                title-key="title"
                :allow-empty-requests="true"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = ''
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'calls onLoad even with empty query', ->
        expect($onLoad).toHaveBeenCalled()
        expect($wrapper.text()).toContain('Empty allowed')

    describe 'when inactive', ->
      def('onLoad', => jest.fn -> Promise.resolve([{ title: 'Inactive' }]))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad}) -> onLoad($onLoad)
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                title-key="title"
                :active="false"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'does not load items when inactive', ->
        expect($onLoad).not.toHaveBeenCalled()
        expect($wrapper.vm.$refs.autocomplete.items).toEqual([])

    describe 'without entity throws on load', ->
      def('onLoad', => jest.fn -> Promise.resolve([]))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad}) -> onLoad($onLoad)
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      beforeEach -> $wrapper

      test 'throws when entity is missing', ->
        component = $wrapper.vm.$refs.autocomplete
        component.query = 'x'
        expect(-> component.instantLoad()).toThrow(/Entity for autocomplete/)

    describe 'with unknown provider', ->
      def('autocompletes', () => [])

      test 'throws when provider is not found', ->
        expect(->
          mount(
            template: """
              <rf-form :resource="resource">
                <rf-autocomplete
                  name="title"
                  type="missing"
                  entity="todo"
                  ref="autocomplete"
                />
              </rf-form>
            """
            data: ->
              resource: { title: '' }
          )
        ).toThrow(/Autocomplete provider for missing not found/)

    describe 'with items slot', ->
      def('onLoad', => jest.fn -> Promise.resolve([{ title: 'Slotted items' }]))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad}) -> onLoad($onLoad)
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
              >
                <template #items="{ items, $on }">
                  <div class="custom-items">
                    <span
                      v-for="item in items"
                      class="custom-item"
                      v-on="$on"
                    >{{ item.title }}</span>
                  </div>
                </template>
              </rf-autocomplete>
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'renders the items slot', ->
        expect($wrapper.find('.custom-items').exists()).toBe(true)
        expect($wrapper.text()).toContain('Slotted items')

      describe 'on slot item clicked', ->
        beforeEach ->
          $wrapper.find('.custom-item').trigger('click')
          await $wrapper.vm.$nextTick()

        test 'closes the menu through $on', ->
          expect($wrapper.vm.$refs.autocomplete.menu).toBe(false)

    describe 'with item slot', ->
      def('onLoad', => jest.fn -> Promise.resolve([{ title: 'Slotted item' }]))

      def('autocompletes', () => [
        {
          name: 'sample',
          setup: ({onLoad}) -> onLoad($onLoad)
        }
      ])

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="sample"
                entity="todo"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
              >
                <template #item="{ item, $on, text }">
                  <div class="custom-single-item" v-on="$on">{{ text }}</div>
                </template>
              </rf-autocomplete>
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'renders the item slot with text', ->
        expect($wrapper.find('.custom-single-item').exists()).toBe(true)
        expect($wrapper.text()).toContain('Slotted item')

      describe 'on slot item clicked', ->
        beforeEach ->
          $wrapper.find('.custom-single-item').trigger('click')
          await $wrapper.vm.$nextTick()

        test 'selects the item through onFor $on', ->
          expect($wrapper.vm.$refs.autocomplete.query).toBe('Slotted item')

    describe 'with itemComponent template', ->
      def('onLoad', => jest.fn -> Promise.resolve([{ title: 'Component item' }]))

      def('autocompletes', () => [
        {
          name: 'templated',
          setup: ({onLoad}) -> onLoad($onLoad)
        }
      ])

      beforeEach ->
        config.global.config.globalProperties.VueResourceForm.templates =
          autocomplete:
            templated:
              item:
                name: 'templated-item'
                inheritAttrs: false
                props:
                  item: Object
                  text: [String, Object]
                template: '<div class="tmpl-item">{{ text }}</div>'

      afterEach ->
        config.global.config.globalProperties.VueResourceForm.templates = {}

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="templated"
                entity="todo"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'renders itemComponent', ->
        expect($wrapper.find('.tmpl-item').exists()).toBe(true)
        expect($wrapper.text()).toContain('Component item')

    describe 'with itemsComponent template', ->
      def('onLoad', => jest.fn -> Promise.resolve([{ title: 'Items component' }]))

      def('autocompletes', () => [
        {
          name: 'templated',
          setup: ({onLoad}) -> onLoad($onLoad)
        }
      ])

      beforeEach ->
        config.global.config.globalProperties.VueResourceForm.templates =
          autocomplete:
            templated:
              items:
                name: 'templated-items'
                template: '<div class="tmpl-items">rendered</div>'

      afterEach ->
        config.global.config.globalProperties.VueResourceForm.templates = {}

      def('wrapper', ->
        mount(
          template: """
            <rf-form :resource="resource">
              <rf-autocomplete
                name="title"
                type="templated"
                entity="todo"
                title-key="title"
                ref="autocomplete"
                class="autocomplete"
              />
            </rf-form>
          """
          data: ->
            resource: { title: '' }
        )
      )

      def('input', -> $wrapper.find('input'))

      beforeEach ->
        $wrapper
        $input.element.value = 'test'
        $input.trigger('input')
        await new Promise((resolve) => setTimeout(resolve, 1000))
        await $wrapper.vm.$nextTick()

      test 'renders itemsComponent', ->
        expect($wrapper.find('.tmpl-items').exists()).toBe(true)