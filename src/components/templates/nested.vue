<template>

<rf-form
  :name="name"
  :translation-name="$translationName"
  :key="index"
  :resource="collection[index]"
  :sources="$sources"
  :errors="errorsFor(index)"
  :vuex="$vuex"
  :path="pathFor(index)"
  :path-service="pathService"
  :disabled="$disabled"
  :readonly="$readonly"
  :root-resource="$rootResource"
  @reload-resource="reloadResource"
  @reload-root-resource="reloadRootResource"
  @reload-sources="reloadSources"
  @require-source="requireSource"
  v-if="isCollection && (index !== undefined)"
>
  <slot :resource="collection[index]" :$resource="collection[index]" />
</rf-form>

<component :is="wrapper" v-else-if="isCollection">

  <template v-for="block in $schema">
    <template v-if="typeof block === 'function'">
      <rf-form
        :name="name"
        :translation-name="$translationName"
        v-for="wrapper in block(wrappedCollection)"
        :key="wrapper.index"
        :resource="wrapper.item"
        :sources="$sources"
        :errors="errorsFor(wrapper.index)"
        :vuex="$vuex"
        :path="pathFor(wrapper.index)"
        :path-service="pathService"
        :disabled="$disabled"
        :readonly="$readonly"
        :root-resource="$rootResource"
        @reload-resource="reloadResource"
        @reload-root-resource="reloadRootResource"
        @reload-sources="reloadSources"
        @require-source="requireSource"
      >
        <slot :resource="wrapper.item" :$resource="wrapper.item" />
      </rf-form>
    </template>

    <slot :name="block" v-else />
  </template>

</component>

<rf-form
  :name="name"
  :translation-name="$translationName"
  :resource="nestedResource"
  :sources="$sources"
  :errors="errorsForNestedResource"
  :vuex="$vuex"
  :path="parentPath"
  :path-service="pathService"
  v-else-if="nestedResource"
  :disabled="$disabled"
  :readonly="$readonly"
  :root-resource="$rootResource"
  @reload-resource="reloadResource"
  @reload-root-resource="reloadRootResource"
  @reload-sources="reloadSources"
  @require-source="requireSource"
>
  <slot :resource="nestedResource" />
</rf-form>

</template>


<script  src="../descriptors/nested.js" />