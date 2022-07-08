<template>
<textarea
  v-model="$value"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  @change="onChange"
  @blur="onBlur"
/>
</template>


<script src="../descriptors/textarea.js" />


