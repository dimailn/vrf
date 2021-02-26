<template>
<input
  type="checkbox"
  v-model="$value"
  :disabled="$disabled"
  :name="name"
  :title="label"
/>
</template>

<script lang="coffee" src="../descriptors/checkbox.coffee" />