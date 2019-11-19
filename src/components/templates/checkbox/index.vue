<template>
<input
  type="checkbox"
  v-model="checkboxValue"
  :disabled="$disabled"
  :name="name"
/>
</template>

<script lang="coffee" src="../../descriptors/checkbox" />