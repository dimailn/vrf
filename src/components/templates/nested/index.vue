<template>

<rf-form
  :rf-name="rfName"
  :key="index"
  :resource="collection[index]"
  :errors="errorsFor(index)"
  :vuex="vuex"
  :path="pathFor(index)"
  :path-service="pathService"
  :disabled="$disabled"
  :root-resource="$rootResource"
  v-if="isCollection && (index !== undefined)"
>
  <slot :resource="collection[index]" />
</rf-form>

<component :is="wrapper" v-else-if="isCollection">

  <template v-for="block in $schema">
    <template v-if="typeof block === 'function'">
      <rf-form
        :rf-name="rfName"
        v-for="wrapper in block(wrappedCollection)"
        :key="wrapper.index"
        :resource="wrapper.item"
        :errors="errorsFor(wrapper.index)"
        :vuex="vuex"
        :path="pathFor(wrapper.index)"
        :path-service="pathService"
        :disabled="$disabled"
        :root-resource="$rootResource"
      >
        <slot :resource="wrapper.item" />
      </rf-form>
    </template>

    <slot :name="block" v-else />
  </template>

</component>

<rf-form
  :rf-name="rfName"
  :resource="nestedResource"
  :errors="errorsForNestedResource"
  :vuex="vuex"
  :path="parentPath"
  :path-service="pathService"
  v-else-if="nestedResource"
  :disabled="$disabled"
  :root-resource="$rootResource"
>
  <slot :resource="nestedResource" />
</rf-form>

</template>


<script lang="coffee" src="../../descriptors/nested" />