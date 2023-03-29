import Resource from '@/mixins/resource';

export default {
  name: 'rf-action-result',
  mixins: [
    Resource
  ],
  props: {
    /**
     * Name passed to rf-action
     */
    name: String,
    /**
     * Component to display the result with props `data` and `status`.
     */
    component: [String, Object]
  },
  computed: {
    $result() {
      if(!this.$actionResults) {
        return
      }

      return this.$actionResults[this.name]
    },
    $isSuccess() {
      if(!this.$result) {
        return
      }

      return this.$result.statusHandle === 'SUCCESSFUL'
    },
    $isFailure() {
      if(!this.$result) {
        return
      }

      return !this.$isSuccess
    },
    $isSoftFailure() {
      if(!this.$result) {
        return
      }

      return this.$result.statusHandle === 'SOFT_FAILURE'
    },
    $isNetworkFailure() {
      if(!this.$result) {
        return
      }

      return this.$result.statusHandle === 'NETWORK_FAILURE'
    },
    $isServerFailure() {
      if(!this.$result) {
        return
      }

      return this.$result.statusHandle === 'SERVER_FAILURE'
    }
  }
}
