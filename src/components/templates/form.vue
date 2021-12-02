<template>
<form @submit.prevent>
  <component :is="$loader" v-if="(auto && $fetching || !$resource) && $loader" />


  <div v-if="!$scopedSlots.default && $resource" v-show="$resource && !$fetching">
    <slot  />
  </div>

  <div
    v-else-if="$resource" 
    v-show="$resource && !$fetching" 
  >
    <slot 
      :$resource="$resource" 
    />
  </div>

</form>
</template>

<script src="../descriptors/form.ts" lang="ts" />

