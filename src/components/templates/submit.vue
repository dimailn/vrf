<template>
<button type="button" @click="$submit" v-if="!$disabled">
  <slot>{{humanName}}</slot>
</button>
</template>



<script lang="coffee" src="../descriptors/submit.coffee" />
