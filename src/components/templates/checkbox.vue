<template>

<input
  type="checkbox"
  v-model="$value"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  :title="label"
  :checked="$value"
/>

</template>

<script src="../descriptors/checkbox.js" />