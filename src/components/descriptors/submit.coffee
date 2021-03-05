import Base from '@/components/descriptors/base'

export default {
  extends: Base

  computed:
    $disabled: ->
      return true if @$readonly

      @$originalDisabled

    humanName: ->
      @t('submit', '$vrf')
}
