<template>
<form @submit.prevent>
  <slot v-if="$resource" />
</form>
</template>

<script src="../descriptors/form.ts" />

