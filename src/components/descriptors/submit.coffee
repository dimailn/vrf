import Base from '@/components/descriptors/base'

export default {
  extends: Base

  computed:
    humanName: ->
      @t('submit', '$vrf')
}
