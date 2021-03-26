<template>

<rf-resource v-slot="{actionResults}">
  <component
    :is="component"
    :data="actionResults[name] && actionResults[name].data"
    :status="actionResults[name] && actionResults[name].status"
    v-if="component"
  />
  <slot
    :data="actionResults[name] && actionResults[name].data"
    :status="actionResults[name] && actionResults[name].status"
    v-else
  />
</rf-resource>

</template>


<script lang="coffee" src="../descriptors/action-result.coffee" />
