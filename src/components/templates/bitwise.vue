<template>

<rf-form :resource="wrapper" :disabled="$disabled" :readonly="$readonly">
  <template
    v-if="$_options"
  >
    <rf-checkbox
      :name="option.name || option.title"
      :label="option.title"
      :power="option.id"
      :key="option.id"
      :inverted="inverted"
      v-for="option in $_options"
    />
  </template>

  <slot v-else />
</rf-form>

</template>

<script src="../descriptors/bitwise.js" />