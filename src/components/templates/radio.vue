<template>

<div>
  <input
    :id="$id"
    type="radio"
    :value="$itemValue"
    :checked="$value"
    @change=" $value = $event.target.value"
  />
  <label :for="$id" v-if="label">{{label}}</label>
</div>


</template>

<script src="../descriptors/radio.js" />
