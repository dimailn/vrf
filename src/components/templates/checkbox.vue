<template>
<input
  type="checkbox"
  v-model="$value"
  :disabled="$disabled"
  :name="name"
/>
</template>

<script lang="coffee" src="../descriptors/checkbox.coffee" />