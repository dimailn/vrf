<template>

<input
  :type="password ? 'password' : 'text'"
  v-model="value"
  :disabled="$disabled"
  :name="name"
  @input="onInput"
  @blur="onBlur"
  @change="onChange"
  :placeholder="placeholder"
  @keyup.enter="submit"
/>

</template>

<script lang="coffee" src="../descriptors/input.coffee" />