<template>

<rf-resource v-slot="{actionResults}">
  <template v-if="actionResults && actionResults[name]">
    <component
      :is="component"
      :data="actionResults[name].data"
      :status="actionResults[name].status"
      v-if="component"
    />
    <slot
      :data="actionResults[name].data"
      :status="actionResults[name].status"
      v-else
    />
  </template>
</rf-resource>

</template>


<script src="../descriptors/action-result.js" />
