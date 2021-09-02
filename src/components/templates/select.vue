<template>
<select
  v-model="$value"
  :multiple="multiple"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  v-on="_listeners"
>
  <option v-for="option in $_options" :value="option[idKey]">
    {{ option[titleKey] }}
  </option>
</select>
</template>

<script src="../descriptors/select.js" />
