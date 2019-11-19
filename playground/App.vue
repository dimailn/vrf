<template>
  <div id="app">
    <!-- <img src="./assets/logo.png"> -->

    VRF playfround

    <rf-form :resource="todo">
      <rf-input name="title" />
      <rf-checkbox name="status" />
    </rf-form>

    {{
      todo
    }}
  </div>
</template>

<script lang="coffee">
export default {
  name: 'App'
  data: ->
    todo:
      title: ''
      status: false
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
