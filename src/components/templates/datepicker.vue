<template>
<input
  type="datetime-local"
  :value="date"
  @input="onInput"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
/>
</template>

<script src="../descriptors/datepicker.js" />

