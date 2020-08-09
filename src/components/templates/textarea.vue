<template>
<textarea
  v-model="$value"
  :disabled="$disabled"
  :name="name"
  @input="onInput"
  @change="onChange"
  @blur="onBlur"
/>
</template>


<script lang="coffee" src="../descriptors/textarea.coffee" />


