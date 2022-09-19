<template>

<rf-form :resource="wrapper" :disabled="$disabled" :readonly="$readonly" root-element="div">
  <template
    v-if="$_options"
  >
    <rf-radio
      :label="option[titleKey]"
      :value="option[idKey]"
      :key="option[idKey]"
      v-for="option in $_options"
    />
  </template>

  <slot v-else />
</rf-form>

</template>

<script src="../descriptors/radio-group.js" />