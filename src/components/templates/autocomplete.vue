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


<script src="../descriptors/autocomplete" />


