<template>
<select v-model="value" :multiple="multiple" :disabled="$disabled" :name="name" v-on="_listeners">
  <option v-for="option in $_options" :value="option.id">
    {{ option.title }}
  </option>
</select>
</template>

<script lang="coffee" src="../../descriptors/select" />
