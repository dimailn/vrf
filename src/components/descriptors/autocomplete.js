import BaseInput from '@/components/descriptors/base-input'

import pick from '@/utils/pick'
import get from 'lodash.get'

import debounce from 'lodash.debounce'
import Templates from '@/mixins/templates'

export default {
  name: 'rf-autocomplete',
  extends: BaseInput,
  mixins: [Templates],
  props: {
    type: {
      type: [String, Object, Function],
      required: true
    },
    entity: String,
    limit: [Number, String],
    disabled: [Boolean, String],
    text: String,
    autofocus: Boolean,
    active: {
      type: Boolean,
      default: true
    },
    stateless: Boolean,
    params: Object,
    titleKey: {
      type: [String, Function]
    },
    idKey: {
      type: [String, Function]
    },
    allowEmptyRequests: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      query: '',
      loading: false,
      items: [],
      menu: false
    };
  },
  watch: {
    $value() {
      this.executeEvent('onValueChanged')
    }
  },
  mounted() {
    this.setupAutocomplete()
    this.executeEvent('onMounted')

    document.addEventListener('click', this.handleDocumentClick)
  },

  beforeDestroy(){
    document.removeEventListener('click', this.handleDocumentClick)
  },
  created() {
    this.listeners = {}
  },
  methods: {
    reset() {
      this.query = '';
      return this.$value = null;
    },
    onSelect(item) {
      const result = this.executeEvent('onSelect', [item])

      const {$idKey, titleKey} = this

      if (result instanceof Object) {
        const {value, query} = result

        this.$value = value
        this.query = query
      } else if (titleKey || $idKey) {
        if ($idKey) {
          this.$value = typeof $idKey === 'function' ? $idKey(item) : get(item, $idKey)
        }

        if(titleKey) {
          this.query = typeof titleKey === 'function' ? titleKey(item) : get(item, titleKey)
        }
      }

      return this.$emit('select', item)
    },
    onInput(val) {
      this.$emit('update:text', val)
      this.load()

      this.executeEvent('onInput')

      return this.$emit('input', val)
    },
    focus() {
      return this.$refs.autocomplete.focus();
    },
    onClick() {
      this.executeEvent('onInputClick')

      return this.$emit('click')
    },
    onClear() {
      this.executeEvent('onClear')

      return this.$emit('clear')
    },
    load: debounce(function() {
      if ((this.query != null && this.query.length > 0) || this.allowEmptyRequests) {
        return this.instantLoad()
      } else {
        this.items = []
        this.menu  = false
      }
    }, 400),
    executeEvent(eventName, args = []) {
      const handlers = this.listeners[eventName] || []

      return handlers.reduce((lastResult, handler) => lastResult || handler(...args), undefined)
    },
    instantLoad() {
      if (!this.entity) {
        throw `[vrf] Entity for autocomplete ${this.name} must be defined`;
      }

      if (this.active) {
        this.loading = true

        this.executeEvent('onLoad', [pick(this, ['query', 'limit', 'entity'])])
          .then((items) =>  {
            this.items = items
            this.menu = this.items.length > 0
          })
          .finally(() => this.loading = false)
      }
    },
    onFor(item) {
      return {
        click: this.onSelect.bind(this, item)
      }
    },
    on() {
      return {
        click: this.onSelect
      }
    },
    presentItem(item) {
      const {titleKey} = this

      if(!titleKey) {
        return item
      }

      return typeof titleKey === 'function' ? titleKey(item) : get(item, titleKey)
    },
    setupAutocomplete() {
      const setup = this.providerSetup

      if(!setup) {
        throw `[vrf] Autocomplete provider should contain setup method, but ${this.type} provider doesn't have`
      }

      const context = {
        form: this.$form,
        ...[
          'onLoad',
          'onSelect',
          'onClear',
          'onInput',
          'onMounted',
          'onValueChanged'
        ].reduce((listenerSetups, name) => {
          listenerSetups[name] = (handler) => {
            this.listeners[name] ||= []

            this.listeners[name].push(handler)
          }

          return listenerSetups
        }, {})
      }

      return setup(context)
    },
    handleDocumentClick(e) {
      if (!this.menu) { return }

      const { target } = e
      const { root } = this.$refs

      if (!root.contains(target)) {
        this.menu = false
      }
    }
  },
  computed: {
    itemsComponent() {
      return this.$templates[this.type] && this.$templates[this.type].items
    },
    itemComponent() {
      return this.$templates[this.type] && this.$templates[this.type].item
    },
    hasItemsSlot() {
      return !!this.$scopedSlots.items
    },
    hasItemSlot() {
      return !!this.$scopedSlots.item
    },
    $idKey() {
      return this.idKey || this.titleKey
    },
    providerSetup() {
      if (typeof this.type === 'function') {
        return this.type
      }

      if (typeof this.type === 'object' && this.type !== null && this.type.setup) {
        return this.type.setup
      }

      const vue = Object.getPrototypeOf(this.$root).constructor

      const provider = vue.prototype.VueResourceForm.autocompletes?.find((provider) => provider.name === this.type)


      if (!provider) {
        throw `[vrf] Autocomplete provider for ${this.type} not found`;
      }

      return provider.setup
    }
  }
};
