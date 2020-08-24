<template>
  <div id="app">
    <!-- <img src="./assets/logo.png"> -->

    VRF playground
    <h1> Simple form </h1>
    <div style="display: flex">
      <rf-form :resource="todo" class="form">
        <rf-input v-model="todo.title" />
        <rf-checkbox v-model="todo.status" />
        <rf-input name="title" />
        <rf-checkbox name="status" />
        <rf-switch name="status" />
        <rf-datepicker name="finishTill" />
        <rf-select name="importance" :options="importanceOptions" />
        <rf-textarea name="description" />
        <rf-span name="owner" />
        <rf-select name="priority" options="numerals" />
        <button @click="add">Add</button>
      </rf-form>
      <div style="flex: 1">
        {{todo}}
      </div>
    </div>

    <h1> Nested form </h1>
    <div style="display: flex">
      <rf-form :resource="user" class="form">
        <rf-nested name="todos">
          <template slot-scope="props">
            <div class="form">
              <rf-input name="title" />
              <rf-checkbox name="status" />
              <rf-datepicker name="finishTill" />
              <rf-select name="importance" :options="importanceOptions" />
              <rf-textarea name="description" />
              <rf-span name="owner" />

              <h2> rf-resource example </h2>
              <rf-resource>
                <template slot-scope="props">
                  {{props}}
                </template>
              </rf-resource>
            </div>
          </template>
        </rf-nested>

      </rf-form>
      <div style="flex: 1">
        {{user}}
      </div>
    </div>
  </div>
</template>

<script lang="coffee">
export default {
  data: ->
    todo: null
    user:
      todos: [
        {
          title: 'First'
          status: false
          finishTill: null
          importance: null
          description: ''
          owner: 'User #1'
        }
        {
          title: 'Second'
          status: false
          finishTill: null
          importance: null
          description: ''
          owner: 'User #1'
        }
      ]


  created: ->
    @todo = @blank()

  methods:
    add: ->
      @user.todos.push(@todo)

      @todo = @blank()

      # @user.todos.push(@blank())

    blank: ->
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
