import Base from '../base'

export default {
  extends: Base

  computed:
    humanName: ->
      @t('submit', '$vrf')
}
