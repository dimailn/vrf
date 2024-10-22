import debounce from 'lodash.debounce'
import Resource from '@/mixins/resource'
import {propsFactory} from '@/components/descriptors/form'
import pick from '@/utils/pick'
import {computed} from 'vue'

const nameMapper = (name) => name === 'submit' ? name : `$${name}`

export default {
  name: 'rf-scope',
  mixins: [
    Resource,
  ],
  provide(){
    return {
      vrf: computed(() => this.vrfProvider)
    }
  },
  props: {
    disabled: Boolean,
    readonly: Boolean,
    isolated: Boolean,
    autosave: Boolean,
    delay: {
      type: Number,
      default: 1000
    }
  },
  data() {
    return {
      fieldNames: [],
      saving: false
    }
  },

  created() {
    this.debouncedSubmit = debounce(this.submit, this.delay)
  },

  watch: {
    delay() {
      this.debouncedSubmit = debounce(this.submit, this.delay)
    }
  },

  computed: {
    vrfProvider(){ 
      return Object.fromEntries(
        Object.keys(propsFactory()).map(name => [name, this[nameMapper(name)]])
      )
    },
    $formDisabled() {
      return this.disabled || this.vrf.formDisabled
    },
    $formReadonly() {
      return this.readonly || this.vrf.formReadonly
    },
    $scope() {
      return {
        emit: (eventName, payload) => {
          switch(eventName) {
            case 'initialized':
              this.fieldNames.push(payload)
              break;

            case 'changed':
              if (this.$form.auto && this.autosave) {
                this.debouncedSubmit()
              }
              break;
          }
        }
      }
    }
  },
  methods: {
    submit() {
      if (this.isolated) {
        this.setSyncProp('saving', true)
        this.$form.submit(
          pick(this.$resource, this.fieldNames),
          this.$form.$pathService.getRootByPath(this.$form.path)
        ).finally(() => this.setSyncProp('saving', false))
      } else {
        this.$form.submit()
      }
    },
    setSyncProp(name, value) {
      this[name] = value
      this.$emit(`update:${name}`, value)
    }
  },
  render() {
    return this.$slots.default()
  }
}