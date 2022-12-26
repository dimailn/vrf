<template>
  <div id="app">
    <!-- <img src="./assets/logo.png"> -->

    VRF playground
    <h1> Simple form </h1>
    <div style="display: flex">
      <rf-form
        v-model="todo"
        class="form"
        v-slot="{$resource}"
      >
        <rf-scope :disabled="$resource.title.length > 5">
          <rf-input name="title" />

          <rf-checkbox name="status" />
          <rf-switch name="status" />
        </rf-scope>

        <rf-datepicker name="finishTill" />
        <rf-select name="importance" :options="importanceOptions" />
        <rf-textarea name="description" />
        <rf-span name="owner" />
        <rf-select name="priority" options="numerals" />

        <h3>Bitwise field</h3>
        <h4>Markup based</h4>
        <rf-bitwise name="flags">
          <rf-checkbox name="some 1" power="1" />
          <rf-checkbox name="some 2" power="2" />
        </rf-bitwise>

        <h4>Options based(inverted)</h4>
        <rf-bitwise
          name="flags"
          :options="[{id: 1, title: 'some 1'}, {id: 2, title: 'some 2'}]"
          inverted
        />

        <h4>Radio Group</h4>

        <rf-radio-group name="radio">
          <rf-radio value="Alaska FM" label="Alaska FM" />
          <rf-radio value="BBC" label="BBC" />
        </rf-radio-group>

        <rf-radio-group name="radio" :options="[{id: 'Alaska FM', title: 'Alaska FM'}, {id: 'BBC', title: 'BBC'}]" />

        <button @click="add">Add</button>
      </rf-form>
      <div style="flex: 1">
        {{todo}}
      </div>
    </div>

    <h1>v-model</h1>

    <form>
      <rf-input />
      <rf-checkbox v-model="todo.status" />
      <rf-switch v-model="todo.status" />
      <rf-datepicker v-model="todo.finishTill" />
      <rf-select v-model="todo.importance" :options="importanceOptions" />
      <rf-textarea v-model="todo.description" />
    </form>

    <h1> Nested form </h1>
    <div style="display: flex">
      <rf-form v-model="user" class="form">
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
              <rf-resource v-slot="{resource}">
                {{resource}}
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

<script>

export default {
  data() {
    return {
      todo: null,
      user: {
        todos: [
          {
            title: 'First',
            status: false,
            finishTill: null,
            importance: null,
            description: '',
            owner: 'User #1'
          },
          {
            title: 'Second',
            status: false,
            finishTill: null,
            importance: null,
            description: '',
            owner: 'User #1'
          }
        ]
      }
    }
  },

  created(){
    this.todo = this.blank()
  },

  methods: {
    add(){
      this.user.todos.push(this.todo)

      this.todo = this.blank()

      // this.user.todos.push(this.blank())
    },


    blank() {
      return {
        title: '',
        status: false,
        finishTill: null,
        importance: null,
        description: '',
        owner: 'User #1',
        flags: 0,
        testFile: null
      }
    }
  },
  computed: {
    importanceOptions(){
      return [
        {
          id: 1, title: 'Low'
        },
        {
          id: 2, title: 'High'
        }
      ]
    }
  }
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
