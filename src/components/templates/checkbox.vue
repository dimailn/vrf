<template>
<input
  type="checkbox"
  v-model="$value"
  :disabled="$disabled"
  :name="name"
  @input="onInput"
/>
</template>

<script lang="coffee" src="../descriptors/checkbox.coffee" />