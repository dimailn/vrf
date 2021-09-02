export default {
  name: 'rf-action-result',
  props: {
    /**
     * Name passed to rf-action
     */
    name: String,
    /**
     * Component to display the result with props `data` and `status`.
     */
    component: [String, Object]
  }
};
