<template>
<button type="button" @click="submit" v-if="!$disabled">
  <!-- need i18n, temporary workaround -->
  <slot />
</button>
</template>



<script lang="coffee" src="../../descriptors/submit" />
