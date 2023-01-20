<template>
<div ref="root">
  <input
    v-model="query"
    :disabled="$disabled"
    :readonly="$readonly"
    :name="name"
    @blur="onBlur"
    @input="onInput"
    @click="onClick"
  />
  <div v-if="menu">
    <slot name="items" v-if="hasItemsSlot" :items="items" :$on="on()" />
    <ul v-else-if="hasItemSlot">
      <slot
        name="item"
        v-for="item in items"
        :item="item"
        :$on="onFor(item)"
        :text="presentItem(item)"
      >
        <li @click="onSelect(item)">{{presentItem(item)}}</li>
      </slot>
    </ul>
    <component :is="itemsComponent" v-else-if="itemsComponent" />
    <ul v-else-if="itemComponent">
      <component
        :is="itemComponent"
        v-for="item in items"
        :item="item"
        :$on="onFor(item)"
        :text="presentItem(item)"
      />
    </ul>

    <ul v-else>
      <li
        v-for="item in items"
        @click="onSelect(item)"
      >
        {{presentItem(item)}}
      </li>
    </ul>
  </div>
</div>
</template>


<script src="../descriptors/autocomplete.js" />


