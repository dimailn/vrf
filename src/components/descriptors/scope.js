import Resource from '@/mixins/resource'
import {propsFactory} from '@/components/descriptors/form'
import VueProvideObservable from 'vue-provide-observable'

const nameMapper = (name) => `$${name}`

export default {
  name: 'rf-scope',
  mixins: [
    Resource,
    VueProvideObservable('vrf', propsFactory, nameMapper)
  ],
  props: {
    disabled: Boolean,
    readonly: Boolean
  },
  computed: {
    $formDisabled() {
      return this.disabled || this.vrf.wrapper.formDisabled
    },
    $formReadonly() {
      return this.readonly || this.vrf.wrapper.formReadonly
    }
  },
  render(h) {
    if (this.$slots.default.length > 1) {
      return h('div', {}, this.$slots.default)
    }

    return this.$slots.default
  }
}