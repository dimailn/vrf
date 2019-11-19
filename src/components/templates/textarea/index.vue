<template>
<textarea
  v-model="value"
  :disabled="$disabled"
  :name="name"
  @input="onInput"
  @blur="onBlur"
/>
</template>


<script lang="coffee" src="../../descriptors/textarea" />


