<template>
<form @submit.prevent>
  <slot v-if="!$scopedSlots.default" />
  <slot :$resource="resource" v-else-if="$resource" />
</form>
</template>

<script src="../descriptors/form.ts" lang="ts" />

