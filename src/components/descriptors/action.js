import Resource from '@/mixins/resource';

import Translate from '@/mixins/translate';

export default {
  name: 'rf-action',
  props: {
    name: String,
    params: Object, // Body params
    data: Object,
    method: String, // Request HTTP method
    url: String, // Override default based on name
    label: String,
    labelName: String,
    reloadOnResult: Boolean
  },
  mixins: [Resource, Translate],
  computed: {
    $label() {
      if (this.label) {
        return this.label;
      }
      return this.t(this.labelName || this.name, this.$translationName, { isAction: true });
    },
    humanName: function() {
      console.warn('[vrf] Computed property humanName is deprecated, use $label instead')

      return this.$label
    },
    $on() {
      return {
        click: this.onClick
      }
    }
  },
  render: function(h) {
    if (this.$scopedSlots.activator) {
      const nodes = this.$scopedSlots['activator']({
        humanName: this.$label,
        label: this.$label,
        on: this.$on,
        pending: this.$actionPendings[this.name] || false
      })

      if (nodes.length > 1) {
        return h('div', null, nodes)
      } else {
        return nodes
      }
    } else {
      return this.renderByDefault(h)
    }
  },
  methods: {
    renderByDefault(h){
      return h(
        'button',
        {
          on: this.$on
        },
        this.$label
      )
    },
    onClick() {
      return this.$form.executeAction(this.name, {
        params: this.params,
        data: this.data,
        method: this.method,
        url: this.url
      }).then((result) => {
        if (this.reloadOnResult) {
          this.$form.reloadResource();
        }
        return this.$emit('result', result);
      });
    }
  }
};
