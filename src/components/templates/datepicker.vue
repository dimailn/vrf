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

<script lang="coffee" src="../descriptors/datepicker.coffee" />

