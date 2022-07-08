<template>

<input
  :type="$type"
  v-model="$value"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  @blur="onBlur"
  @change="onChange"
  :placeholder="placeholder"
  @keyup.enter="submit"
/>

</template>

<script src="../descriptors/input.js" />