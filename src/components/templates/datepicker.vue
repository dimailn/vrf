<template>
<input
  type="datetime-local"
  :value="date"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  @input="onInput"
/>
</template>

<script src="../descriptors/datepicker.js" />

