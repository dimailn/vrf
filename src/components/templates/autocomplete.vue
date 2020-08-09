<template>
<input
  v-model="$value"
  :disabled="$disabled"
  :name="name"
  @input="onInput"
  @blur="onBlur"
/>
</template>


<script lang="coffee" src="../../descriptors/autocomplete.coffee" />


