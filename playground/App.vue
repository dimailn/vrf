<template>
  <div id="app">
    <!-- <img src="./assets/logo.png"> -->

    VRF playfround

    <div style="display: flex">
      <rf-form :resource="todo" class="form">
        <rf-input name="title" />
        <rf-checkbox name="status" />
        <rf-datepicker name="finishTill" />
        <rf-select name="importance" :options="importanceOptions" />
        <rf-textarea name="description" />
        <rf-span name="owner" />
      </rf-form>
      <div style="flex: 1">
        {{todo}}
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  name: 'App'
  data: ->
    todo:
      title: ''
      status: false
      finishTill: null
      importance: null
      description: ''
      owner: 'User #1'
  computed:
    importanceOptions: ->
      [
        {
          id: 1, title: 'Low'
        }
        {
          id: 2, title: 'High'
        }
      ]
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
.form{
  display: flex;
  flex-direction: column;
  flex: 1;
}
</style>
