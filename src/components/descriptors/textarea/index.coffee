import Base from '../base'
import {textarea} from '../../prop_types'
import baseProps from '../../prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    ...textarea
  }
}
