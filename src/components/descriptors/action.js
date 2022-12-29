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
    humanName: function() {
      if (this.label) {
        return this.label;
      }
      return this.t(this.labelName || this.name, this.$translationName, { isAction: true });
    }
  },
  render: function(h) {
    var events, nodes;
    events = {
      click: this.onClick
    };
    if (this.$scopedSlots.activator) {
      nodes = this.$scopedSlots['activator']({
        humanName: this.humanName,
        on: events,
        pending: this.$actionPendings[this.name] || false
      });
      if (nodes.length > 1) {
        return h('div', null, nodes);
      } else {
        return nodes;
      }
    } else {
      return h('button', {
        on: events
      }, this.humanName);
    }
  },
  methods: {
    onClick: function() {
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
