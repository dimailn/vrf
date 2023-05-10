import BaseInput from '@/components/descriptors/base-input';

export default {
  name: 'rf-file',
  extends: BaseInput,
  props: {
    multiple: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onChange(e){
      this.setFiles(this.multiple ? e.target.files : e.target.files[0])

      this.$emit('change', e)
    },
    setFiles(fileOrFiles) {
      this.$value = Object.preventExtensions(fileOrFiles)
    }
  }
}