<template>
<input
  type="datetime-local"
  :value="date"
  @input="onInput"
  :disabled="$disabled"
  :name="name"
/>
</template>

<script lang="coffee" src="../../descriptors/datepicker" />

