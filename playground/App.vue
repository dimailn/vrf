<template>
  <div id="app">
    <div class="container">
      <img class="logo" src="/static/logo.png">
      <h1> Simple form </h1>
      <div class="column">
        <rf-form v-model="todo" class="form" v-slot="{ $resource }">
          <rf-scope :disabled="$resource.title.length > 5">
            <div class="field">
              <div class="field-label">
                title
              </div>
              <rf-input name="title" />
            </div>
            <div class="field">
              <div class="field-label">
                status
              </div>
              <rf-checkbox name="status" />
              <rf-switch name="status" />
            </div>
          </rf-scope>

          <div class="field">

            <div class="field-label">
              finishTill
            </div>
            <rf-datepicker name="finishTill" />
          </div>

          <div class="field">
            <div class="field-label">
              importance
            </div>
            <rf-select name="importance" :options="importanceOptions" />
          </div>

          <div class="field">
            <div class="field-label">
              description
            </div>
            <rf-textarea name="description" />
          </div>

          <div class="field">
            <div class="field-label">
              priority
            </div>
            <rf-span name="owner" />
            <rf-select name="priority" options="numerals" />
          </div>

          <h2>Bitwise field</h2>
          <h4>Markup based</h4>
          <div class="field">
            <rf-bitwise name="flags">
              <rf-checkbox name="some 1" power="1" />
              <rf-checkbox name="some 2" power="2" />
            </rf-bitwise>
          </div>

          <h4>Options based(inverted)</h4>
          <div class="field">
            <rf-bitwise name="flags" :options="[{ id: 1, title: 'some 1' }, { id: 2, title: 'some 2' }]" inverted />
          </div>

          <h4>Radio Group</h4>

          <div class="field">
            <rf-radio-group name="radio">
              <rf-radio value="Alaska FM" label="Alaska FM" />
              <rf-radio value="BBC" label="BBC" />
            </rf-radio-group>
          </div>

          <div class="field">
            <rf-radio-group name="radio"
              :options="[{ id: 'Alaska FM', title: 'Alaska FM' }, { id: 'BBC', title: 'BBC' }]" />
          </div>

          <button @click="add">Add</button>
        </rf-form>
        <div>
          <code class="code sticky-top"><pre>{{ JSON.stringify(todo, null, 2) }}</pre></code>
        </div>
      </div>



      <h1>v-model</h1>

      <div class="column">
        <form>
          <div class="field">
            <div class="field-label">
              title
            </div>
            <rf-input v-model="todo.title" />
          </div>
          <div class="field">
            <div class="field-label">
              status
            </div>
            <rf-checkbox v-model="todo.status" />
          </div>
          <div class="field">
            <div class="field-label">
              status
            </div>
            <rf-switch v-model="todo.status" />
          </div>
          <div class="field">
            <div class="field-label">
              finishTill
            </div>
            <rf-datepicker v-model="todo.finishTill" />
          </div>
          <div class="field">
            <div class="field-label">
              importance
            </div>
            <rf-select v-model="todo.importance" :options="importanceOptions" />
          </div>
          <div class="field">
            <div class="field-label">
              description
            </div>
            <rf-textarea v-model="todo.description" />
          </div>
        </form>
        <div>
          <code class="code sticky-top"><pre>{{ JSON.stringify(todo, null, 2) }}</pre></code>
        </div>
      </div>


      <h1> Nested form </h1>
      <div class="column">
        <rf-form v-model="user" class="form">
          <rf-nested name="todos">
            <template slot-scope="props">
              <div class="form">
                <h2>Nested item</h2>
                <div class="field">
                  <rf-input name="title" />
                </div>
                <div class="field">
                  <rf-checkbox name="status" />
                </div>
                <div class="field">
                  <rf-datepicker name="finishTill" />
                </div>
                <div class="field">
                  <rf-select name="importance" :options="importanceOptions" />
                </div>
                <div class="field">
                  <rf-textarea name="description" />
                </div>
                <div class="field">
                  <rf-span name="owner" />
                </div>

                <h4>rf-resource example</h4>
                <rf-resource v-slot="{ resource }">
                  <code class="code"><pre>{{ JSON.stringify(resource, null, 2) }}</pre></code>
                </rf-resource>
              </div>
            </template>
          </rf-nested>

        </rf-form>

        <div>
          <code class="code sticky-top"><pre>{{ JSON.stringify(user, null, 2) }}</pre></code>
        </div>
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

  created() {
    this.todo = this.blank()
  },

  methods: {
    add() {
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
    importanceOptions() {
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
  color: #2c3e50;
  margin-top: 60px;
}

.form {
  display: flex;
  flex-direction: column;
  flex: 1;
  margin-bottom: 32px;
}

.container {
  max-width: 1200px;
  margin-left: auto;
  margin-right: auto;
}

.logo {
  height: 100px;
  display: block;
  object-fit: contain;
  object-position: center;
  width: 100%;
}

.code {
  background-color: hsl(0 0% 95% / 1);
  padding: 10px 20px;
  text-align: left;
  font-size: 20px;
  display: block;
  border-radius: 8px;
}

.column {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 40px;
}

.field {
  display: block;
  margin-bottom: 8px;
}

.field-label {
  margin-bottom: 2px;
}

input[type="text"],
input[type="datetime-local"],
textarea {
  padding: 4px;
  display: block;
  font-size: 16px;
  border-radius: 4px;
  border: 1px solid #898989;
}

select {
  padding: 4px;
  font-size: 16px;
  border-radius: 4px;
  border-color: #898989;
}

button {
  padding: 8px 16px;
  background: #00B981;
  color: #fff;
  font-size: 16px;
  border: none;
  border-radius: 4px;
  min-width: 200px;
}

.sticky-top {
  position: sticky;
  top: 16px;
}
</style>
