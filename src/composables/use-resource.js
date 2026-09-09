import { inject, computed, isRef } from 'vue'

import FIELDS_FROM_CONTEXT from '../context-fields'

// Composition API alternative to the Resource mixin.
//
// Call it in `setup()` of any descendant of an `<rf-form>` to get reactive
// access to the form context:
//
//   const { resource, errors, submit } = useResource()
//
// Every field the form provides is returned as a computed ref. When used
// outside of a form the refs simply resolve to `undefined`.
export default function useResource() {
  const vrf = inject('vrf', {})

  const context = () => (isRef(vrf) ? vrf.value : vrf) || {}

  return Object.fromEntries(
    FIELDS_FROM_CONTEXT.map(name => [
      name,
      computed(() => context()[name])
    ])
  )
}
