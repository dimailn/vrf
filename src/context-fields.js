// Fields the form exposes through its provide/inject context.
// Shared by the Resource mixin and the useResource composable so the two
// ways of reaching the form context can never drift apart.
export default [
  'resource',
  'sources',
  'fetching',
  'vuex',
  'rfName',
  'errors',
  'submit',
  'saving',
  'form',
  'actionResults',
  'actionPendings',
  'lastSaveFailed',
  'requireSource',
  'translationName',
  'rootResource',
  'formDisabled',
  'formReadonly',
  'scope'
]
