<template>
<button type="button" @click="$submit" v-if="!$disabled">
  <slot>{{humanName}}</slot>
</button>
</template>



<script src="../descriptors/submit.js" />
