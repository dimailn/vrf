<template>

<rf-resource v-slot="{actionResults}" v-if="actionResults && actionResults[name]">
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
</rf-resource>

</template>


<script lang="coffee" src="../descriptors/action-result.coffee" />
