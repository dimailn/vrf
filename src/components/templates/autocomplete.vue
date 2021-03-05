<template>
<input
  v-model="$value"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  @input="onInput"
  @blur="onBlur"
/>
</template>


<script lang="coffee" src="../../descriptors/autocomplete.coffee" />


