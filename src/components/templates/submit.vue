<template>
<button type="button" @click="$submit" v-if="!$disabled">
  <slot>{{$label}}</slot>
</button>
</template>



<script src="../descriptors/submit.js" />
