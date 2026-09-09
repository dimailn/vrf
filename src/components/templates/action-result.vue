<template>

<rf-resource>
  <template #default v-if="$result">
    <component
      :is="component"
      :data="$result.data"
      :status="$result.status"
      v-if="component"
    />
    <slot
      :data="$result.data"
      :status="$result.status"
      v-else
    />

    <slot
      name="success"
      :data="$result.data"
      :status="$result.status"
      v-if="$isSuccess"
    />

    <slot
      name="failure"
      :data="$result.data"
      :status="$result.status"
      v-if="$isFailure"
    />

    <slot
      name="soft-failure"
      :data="$result.data"
      :status="$result.status"
      v-if="$isSoftFailure"
    />

    <slot
      name="network-failure"
      :data="$result.data"
      :status="$result.status"
      v-if="$isNetworkFailure"
    />

    <slot
      name="server-failure"
      :data="$result.data"
      :status="$result.status"
      v-if="$isServerFailure"
    />
  </template>
</rf-resource>

</template>


<script src="../descriptors/action-result.js" />
