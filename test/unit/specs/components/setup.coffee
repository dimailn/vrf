import { config } from '@vue/test-utils'
import Vrf from '../../../../src'

config.global.plugins ||= []
config.global.plugins.push(Vrf)
