import Base from '@/components/descriptors/base'
import {textarea} from '@/components/prop_types'
import baseProps from '@/components/prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    ...textarea
  }
}
