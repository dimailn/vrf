<template>

<div>
  <input
    :id="$id"
    type="radio"
    :value="value"
    v-model="$value"
  />
  <label :for="$id" v-if="label">{{label}}</label>
</div>


</template>

<script src="../descriptors/radio.js" />
