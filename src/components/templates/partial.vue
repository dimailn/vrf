<template>
<component :is="component" :resource="resource" :rf-name="$rfName" :callback="callback">
  <slot />
</component>
</template>

<script lang="coffee" src="../descriptors/partial.coffee" />
