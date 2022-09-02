<template>
<input
  type="file"
  :disabled="$disabled"
  :readonly="$readonly"
  :name="name"
  :multiple="multiple"
  @change="onChange"
/>
</template>

<script src="../descriptors/file.js" />

