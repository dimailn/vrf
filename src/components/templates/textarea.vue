<template>
<textarea
  v-model="$value"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  @input="onInput"
  @change="onChange"
  @blur="onBlur"
/>
</template>


<script lang="coffee" src="../descriptors/textarea.coffee" />


