<template>

<rf-form
  :name="rfName"
  :key="index"
  :resource="collection[index]"
  :resources="$sources"
  :errors="errorsFor(index)"
  :vuex="vuex"
  :path="pathFor(index)"
  :path-service="pathService"
  :disabled="$disabled"
  :readonly="$readonly"
  :root-resource="$rootResource"
  @reload-resource="reloadResource"
  @reload-root-resource="reloadRootResource"
  @reload-sources="reloadSources"
  v-if="isCollection && (index !== undefined)"
>
  <slot :resource="collection[index]" />
</rf-form>

<component :is="wrapper" v-else-if="isCollection">

  <template v-for="block in $schema">
    <template v-if="typeof block === 'function'">
      <rf-form
        :name="rfName"
        v-for="wrapper in block(wrappedCollection)"
        :key="wrapper.index"
        :resource="wrapper.item"
        :resources="$sources"
        :errors="errorsFor(wrapper.index)"
        :vuex="vuex"
        :path="pathFor(wrapper.index)"
        :path-service="pathService"
        :disabled="$disabled"
        :readonly="$readonly"
        :root-resource="$rootResource"
        @reload-resource="reloadResource"
        @reload-root-resource="reloadRootResource"
        @reload-sources="reloadSources"
      >
        <slot :resource="wrapper.item" />
      </rf-form>
    </template>

    <slot :name="block" v-else />
  </template>

</component>

<rf-form
  :name="rfName"
  :resource="nestedResource"
  :resources="$sources"
  :errors="errorsForNestedResource"
  :vuex="vuex"
  :path="parentPath"
  :path-service="pathService"
  v-else-if="nestedResource"
  :disabled="$disabled"
  :readonly="$readonly"
  :root-resource="$rootResource"
  @reload-resource="reloadResource"
  @reload-root-resource="reloadRootResource"
  @reload-sources="reloadSources"
>
  <slot :resource="nestedResource" />
</rf-form>

</template>


<script lang="coffee" src="../descriptors/nested.coffee" />