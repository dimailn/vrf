<template>
<component :is="component" :resource="$resource" :rf-name="$rfName" :callback="callback">
  <slot />
</component>
</template>

<script  src="../descriptors/partial" />
