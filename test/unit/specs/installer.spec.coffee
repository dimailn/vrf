import Vrf, {RfInput} from '../../../src'
import capitalize from '../../../src/utils/capitalize'
import { createApp } from 'vue'


describe 'installer', ->
  def('app', -> createApp({}))
  def('componentSpy', -> jest.spyOn($app, 'component'))
  def('RfInput', ->
    {
      vrfParent: 'input'
      render: (h) ->
        h 'div'
    }
  )
  def('adapter', ->
    {
      name: 'vrf-test-adapter'
      components: {
        RfInput: $RfInput
      }
    }
  )
  describe 'with adapter', ->
    subject -> do -> $componentSpy; $app.use(Vrf, adapters: [$adapter]); $app

    it 'installs', ->
      $subject
      expect($componentSpy).toHaveBeenCalledWith('RfInput', $RfInput)
      expect($RfInput.computed.$vrfParent()).toBe RfInput
      expect($RfInput.extends.name).toBe 'rf-input'

  describe 'with second adapter', ->
    def('RfInput2', ->
      {
        vrfParent: 'input'
        render: (h) ->
          h 'div'
      }
    )

    def('adapter2', ->
      {
        name: 'vrf-test-adapter2'
        components: {
          RfInput: $RfInput2
        }
      }
    )

    subject -> do -> $componentSpy; $app.use(Vrf, adapters: [$adapter, $adapter2]); $app

    it 'can access vrfParent and vrfParentCore', ->
      $subject

      expect($componentSpy).toHaveBeenCalledWith('RfInput', $RfInput2)
      expect($RfInput2.computed.$vrfParent()).toBe $RfInput
      expect($RfInput2.computed.$vrfCoreParent()).toBe RfInput
      expect($RfInput2.extends.name).toBe 'rf-input'

  describe 'without adapter', ->
    subject -> do -> $componentSpy; $app.use(Vrf, adapters: []); $app

    it 'installs core components', ->
      $subject
      expect($componentSpy).toHaveBeenCalledWith('RfInput', RfInput)

  describe 'with adapter but without overriding', ->
    def('adapter', ->
      {
        name: 'vrf-test-adapter'
        components: {
          RfCustomInput: $RfInput
        }
      }
    )
    subject -> do -> $componentSpy; $app.use(Vrf, adapters: [$adapter]); $app

    it 'installs core components', ->
      $subject
      expect($componentSpy).toHaveBeenCalledWith('RfInput', RfInput)

  describe 'with defaultProps', ->
    describe 'without adapter', ->
      subject -> do -> $componentSpy; $app.use(Vrf, defaultProps: {
        RfInput:
          disabled: true
          password: true
      }); $app

      it "set default value for props", ->
        $subject

        expect(RfInput.props.disabled.default).toBe true
        expect(RfInput.props.password.default).toBe true

    describe "with adapter", ->
      describe "default props", ->
        subject -> do -> $componentSpy; $app.use(Vrf, {
          defaultProps: {
            RfInput:
              disabled: true
              password: true
          },
          adapters: [$adapter]
        }); $app

        it "set default value for props", ->
          $subject

          expect($RfInput.props.disabled.default).toBe true
          expect($RfInput.props.password.default).toBe true

      describe "default attribute", ->
        subject -> do -> $componentSpy; $app.use(Vrf, {
          defaultProps: {
            RfInput:
              outlined: true
          },
          adapters: [$adapter]
        }); $app

        it "set default value for attribute", ->
          $subject

          expect($RfInput.defaultAttrs.outlined).toBe true

  describe 'defaultProps validation', ->
    def('error', -> jest.spyOn(console, 'error').mockImplementation(->))

    subject -> do -> $error; $app.use(Vrf, defaultProps: 'not-an-object'); $app

    it 'errors when defaultProps is not an object', ->
      $subject
      expect($error).toHaveBeenCalledWith(expect.stringContaining('defaultProps property should be an object'))

  describe 'defaultProps for unregistered component', ->
    def('warn', -> jest.spyOn(console, 'warn').mockImplementation(->))

    subject -> do -> $warn; $app.use(Vrf, defaultProps: { RfNonExistent: { foo: true } }); $app

    it 'warns that the component is not registered', ->
      $subject
      expect($warn).toHaveBeenCalledWith(expect.stringContaining('is not registered'))

  describe 'defaultProps for an object prop definition', ->
    subject -> do -> $componentSpy; $app.use(Vrf, defaultProps: {
      RfInput:
        placeholder: 'enter value'
    }); $app

    it 'copies the prop definition object and sets default', ->
      $subject
      expect(RfInput.props.placeholder.default).toBe 'enter value'
      expect(typeof RfInput.props.placeholder).toBe 'object'

  describe 'adapter with install and templates', ->
    def('installFn', -> jest.fn())

    def('adapter', ->
      {
        name: 'vrf-test-adapter'
        install: $installFn
        templates: {
          Input: { label: 'custom' }
        }
        components: {
          RfInput: $RfInput
        }
      }
    )

    subject -> do -> $componentSpy; $app.use(Vrf, adapters: [$adapter]); $app

    it 'calls adapter.install', ->
      $subject
      expect($installFn).toHaveBeenCalledWith($app)

    it 'merges adapter templates into VueResourceForm.templates', ->
      $subject
      expect($app.config.globalProperties.VueResourceForm.templates.Input).toEqual { label: 'custom' }

  describe 'adapter component without vrfParent', ->
    def('warn', -> jest.spyOn(console, 'warn').mockImplementation(->))

    def('adapter', ->
      {
        name: 'vrf-test-adapter'
        components: {
          RfInput: { render: (h) -> h 'div' }
        }
      }
    )

    subject -> do -> $warn; $app.use(Vrf, adapters: [$adapter]); $app

    it 'warns and skips the component', ->
      $subject
      expect($warn).toHaveBeenCalledWith(expect.stringContaining('has not vrfParent'))

  describe 'adapter component with unknown vrfParent', ->
    def('warn', -> jest.spyOn(console, 'warn').mockImplementation(->))

    def('adapter', ->
      {
        name: 'vrf-test-adapter'
        components: {
          RfInput: { vrfParent: 'NopeParent', render: (h) -> h 'div' }
        }
      }
    )

    subject -> do -> $warn; $app.use(Vrf, adapters: [$adapter]); $app

    it 'warns that the vrf parent is not found', ->
      $subject
      expect($warn).toHaveBeenCalledWith(expect.stringContaining('is not found'))

  describe 'globalProperties', ->
    def('globals', -> $app.config.globalProperties)

    describe 'idFromRoute', ->
      subject -> do -> $app.use(Vrf, {}); $app

      def('form', -> { name: 'Todo' })

      afterEach ->
        Object.defineProperty(window, 'location', {
          value: { pathname: '/' }
          writable: true
        })

      it 'returns undefined when the route does not match', ->
        Object.defineProperty(window, 'location', { value: { pathname: '/unknown' }, writable: true })
        $subject
        expect($globals.VueResourceForm.idFromRoute($form)).toBeUndefined()

      it 'returns the numeric id from the route', ->
        Object.defineProperty(window, 'location', { value: { pathname: '/todos/42' }, writable: true })
        $subject
        expect($globals.VueResourceForm.idFromRoute($form)).toBe 42

      it 'returns null for a new route', ->
        Object.defineProperty(window, 'location', { value: { pathname: '/todos/new' }, writable: true })
        $subject
        expect($globals.VueResourceForm.idFromRoute($form)).toBeNull()

    describe 'translate', ->
      subject -> do -> $app.use(Vrf, {}); $app

      it 'returns null when $t and $te are not available', ->
        $subject
        translate = $globals.VueResourceForm.translate
        expect(translate.call({})).toBeNull()

      it 'returns null when the path has no translation', ->
        $subject
        translate = $globals.VueResourceForm.translate
        ctx = {
          $t: (path) -> path
          $te: (path) -> false
        }
        expect(translate.call(ctx, 'title', 'Todo')).toBeNull()

      it 'returns the translation when it exists', ->
        $subject
        translate = $globals.VueResourceForm.translate
        ctx = {
          $t: (path) -> "value:#{path}"
          $te: (path) -> true
        }
        expect(translate.call(ctx, 'title', 'Todo')).toBe 'value:vrf.models.Todo.title'

      it 'uses defaults scope when modelName is null', ->
        $subject
        translate = $globals.VueResourceForm.translate
        ctx = {
          $t: (path) -> "value:#{path}"
          $te: (path) -> true
        }
        expect(translate.call(ctx, 'title', null)).toBe 'value:vrf.defaults.title'

  describe 'options are copied to globalProperties', ->
    def('effects', -> { foo: 1 })
    def('store', -> { bar: 2 })
    def('idFromRoute', -> -> 5)

    subject -> do -> $app.use(Vrf, {
      effects: $effects
      store: $store
      autocompletes: { a: 1 }
      sources: { s: 1 }
      transforms: { t: 1 }
      locale: 'en'
      loader: 'loader'
      idFromRoute: $idFromRoute
    }); $app

    it 'copies known option names', ->
      $subject
      vrf = $app.config.globalProperties.VueResourceForm
      expect(vrf.effects).toBe $effects
      expect(vrf.store).toBe $store
      expect(vrf.autocompletes).toEqual { a: 1 }
      expect(vrf.sources).toEqual { s: 1 }
      expect(vrf.transforms).toEqual { t: 1 }
      expect(vrf.locale).toBe 'en'
      expect(vrf.loader).toBe 'loader'
      expect(vrf.idFromRoute).toBe $idFromRoute
