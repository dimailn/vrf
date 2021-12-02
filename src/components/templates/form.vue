<template>
<form @submit.prevent>
  <component :is="$loader" v-if="(auto && $fetching || !$resource) && $loader" />

  <slot v-if="!$scopedSlots.default && $resource" v-show="$resource && !$fetching" />

  <slot 
    :$resource="$resource" 
    v-else-if="$resource" 
    v-show="$resource && !$fetching" 
  />
</form>
</template>

<script src="../descriptors/form.ts" lang="ts" />

