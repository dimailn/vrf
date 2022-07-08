<template>
<input
  v-model="$value"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  @blur="onBlur"
/>
</template>


<script src="../descriptors/autocomplete.js" />


