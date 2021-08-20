<p align="center">
  <img width="166" height="115" src="https://raw.githubusercontent.com/dimailn/vrf/master/static/logo.png" alt="vrf logo">
</p>

<a href="https://github.com/dimailn/vrf/actions/workflows/node.js.yml"><img src="https://github.com/dimailn/vrf/actions/workflows/node.js.yml/badge.svg" /></a>

[![Coverage Status](https://coveralls.io/repos/github/dimailn/vrf/badge.svg?branch=master&kill_cache=1)](https://coveralls.io/github/dimailn/vrf?branch=master)
<a href="https://www.npmjs.com/package/vrf"><img alt="npm" src="https://img.shields.io/npm/v/vrf"></a>
<img src="https://img.shields.io/bundlephobia/min/vrf" />
<img src="https://img.shields.io/bundlephobia/minzip/vrf" />


<a href="https://dimailn.github.io/vrf-demo.github.io">Live demo</a>

# Build Setup

``` bash
# install dependencies
npm install

# start playground
npm start
```

# Table of contents

- [What is vrf?](#what-is-vrf)
- [Ideology](#ideology)
- [What does it look like?](#what-does-it-look-like)
- [Basics](#basics)
  - [Object binding](#object-binding)
  - [Access to the resource](#access-to-the-resource)
  - [Where is the resource?](#where-is-the-resource)
  - [Sources](#sources)
  - [Nested entities](#nested-entities)
  - [Autoforms](#autoforms)
  - [Data loading control](#data-loading-control)
  - [Actions](#actions)
    - [Run actions programmatically](#run-actions-programmatically)
  - [Bitwise fields](#bitwise-fields)
- [Advanced](#advanced)
  - [Architecture](#architecture)
  - [Middleware API](#middleware-api)
  - [Adapter API](#adapter-api)

 

# What is vrf?

Vrf (Vue Resource Form) is a solution for quickly writing declarative user interface forms.


First of all vrf is the specification of form components. There are so many great ui frameworks with different components API, so if you want migrate from one to other you will must to refactor each form and probably, it isn't what you want. Vrf provides common abstract standard for forms like pure html forms, but more powerful.

This package contains a set of descriptors for each form element that you can use to create your own implementation.  If you need to add a new property/feature to some component - this is probably an occasion to think about whether it is possible to add it to the core (this can be discussed in issues).  If the it can be added to the core, this will mean that it is included in the standard and all authors of other implementations will also be able to implement it. If this is not possible, the property is added only for the adapter component and will work only for this adapter.

Vrf doesn't depends on current I18n, validation and network interaction libraries. Instead, it provides interfaces for integration with any one.

# Ideology

Vrf puts form at the forefront of your application, but at the same time all high-level features are provided unobtrusively and their activation is implemented explicitly.  The main thesis of vrf is to stay simple while it is possible.  This means, for example, that you can make the most of the built-in autoforming capabilities and not write any code, but if one day you need a more complex flow than middleware can offer, you can simply turn off the auto mode and manually manipulate the form, while still taking the other advantages that  gives vrf.

In other words, the complex things have the right to be complex, but simple must remain simple.

# What does it look like?

It allows you to write forms in this way:

```vue
<rf-form name="User" auto>
  <rf-input name="firstName" />
  <rf-input name="lastName" />
  <rf-switch name="blocked" />
  <rf-select name="roleId" options="roles" />
  <rf-textarea name="comment" />
  <rf-submit>Save</rf-submit>
</rf-form>

```


Such form will load and save data without a single line of Javascript code. This is possible due to the use of the middleware, which describes the general logic of working with entities in your project. If some form required very specific logic, the form can be used in a lower level mode(without "auto" flag).

## Features

* expressive syntax
* ease of separation
* I18n
* Serverside validations
* autoforms
* nested entities
* option ```disabled``` / ```readonly``` for entire form
* vuex integration

# Basics

 ## Object binding

Binding to an object is the cornerstone of vrf.  This concept assumes that instead of defining a v-model for a field each time, you do a binding once — entirely on the form object, and simply inform each component of the form what the name of the field to which it is attached is called.  Due to this knowledge, the form can take on the tasks of internationalization and display of validations (whereas when determining the v-model for each field, you are forced to do it yourself).

```vue
<template>

<rf-form :resource="resource" :errors="errors">
  <rf-input name="title">
</rf-form>

</template>

<script>

export default {
  data(){
    return {
       resource: {
          title: ""
       },
       errors:{
         title: 'Should not be empty'
       }
    }
  }
}


</script>
```

## Access to the resource

The form passes a reactive context to all child components (using the Provide / Inject API), so any descendant of the form (not even direct) can receive this data.  This allows you to break complex forms into parts, but without the need, it is better not to use this opportunity and try to keep the entire form in one file.

There are several ways to access the resource:

* use rf-resource component

```vue
<rf-resource>
  <template v-slot="props">
    <div>{{props.resource}}</div>
  </template>
</rf-resource>
```

* use Resource mixin

```vue

<template>

<div>
  {{$resource}}
</div>

</template>

<script>

import {Resource} from 'vrf'

export default {
   mixins: [
    Resource
   ]
}

</script>

```

* implement your own component using accessible descriptors

```vue

<template>
<div>
  <input v-model="$value" />
  {{$resource}}
</div>
</template>

<script>

import {descriptors} from 'vrf'

export default {
  extends: descriptors.input
}

</script>
```

## Where is the resource?

The resource can be in three places:

* in the state of the parent component for the form
* in the state of form(this happens in autoforms, or for example if you do not pass a ```resource``` prop). In this case, you can get a reference to the resource using ```:resource.sync``` prop.
* in vuex


## Sources

Some components (for example, such as selects) require options for their work.  For these purposes, the form
```sources``` property serves.  It expects a hash of all the necessary options that can be accessed in specific components by name.

```vue

<template>

<rf-form :resource="todo" :sources="sources">
  <rf-select name="status" options="statuses" />
</rf-form>

</template>

<script>

export default {
  data(){
    return {
      resource: {
        status: 1
      },
      sources: {
        statuses: [
          {
            id: 1,
            title: 'pending'
          },
          {
            id: 2,
            title: 'ready'
          }
        ]
      }
    }
  }
}

</script>
```
Instead of a string with the name of the options, you may also pass directly an array of options(but it is used less often since vrf's strength is precisely the declarative descriptions of forms and autoforms can load sources by name).

When you use a source name with autoforms, form uses a middleware to load the collection for a source. Internally, this is achieved by calling the method ```requireSource``` on the form when component was mounted or ```options``` prop was updated. Then the form chooses the most effective loading strategy depending on the stage at which the method ```requireSource``` was called. You may use this method in your own components, when you need sources for their work.


## Nested entities
Vrf supports work with nested entities, both single and with collections. To work with them, the ```rf-nested``` component is used, which expects a scoped slot with form components for a nested entity. Internally, ```rf-nested``` uses the ```rf-form``` the required number of times, so the use of rf-nested can be equated with the declaration of the form inside the form, which can be duplicated if necessary.

```vue
<template>

<rf-form :resource="todo">
  <rf-input name="title" />
  <rf-nested name="subtasks" rf-name="subtask">
    <template v-slot="props">
      <rf-input name="title">
      <rf-datepicker name="deadline" />
    </template>
  </rf-nested>
</rf-form>

</template>

<script>

export default {
  data(){
    return {
      resource: {
        title: '',
        subtasks: [
          {
            title: '',
            deadline: new Date
          }
        ]
      }
    }
  }
}


</script>


```


## Autoforms

Autoforms are a special form mode in which the form within itself performs tasks of loading, saving data, forwarding validation errors, and can also perform some side effects, for example, redirecting to a page of a newly created entity.

The logic of autoforms is in the middlewares, which are supplied separately from the vrf. Due to this, it is possible to realize the work of autoforms for the specifics of any project. You can use ready-made middleware or implement your own.


Middlewares are set during initialization of forms, and there may be several of them. The form will use the first suitable middleware, the static ```accepts``` method is used to determine applicability. The form has a special prop ```transport``` that allows you to specify the preferred middleware (which should respond to a specific value of the prop ```transport```).


## Data loading control

Vrf provide some methods on rf-form allows you to manage data loading:

```javascript

$refs.form.forceReload() // Completely reloading, excplicitly displayed to user

$refs.form.reloadResource() // Reload only resource without showing loaders

$refs.form.reloadResource(['messages']) // Reload only 'messages' key on resource

$refs.form.reloadSources() // Reload only sources

$refs.form.reloadRootResource(['options']) // reload root form resource, useful if nested component affects data on top level

```

Method ```reloadResource``` allows you to write custom components which may reload the piece of data they are responsible for.

```javascript
import {descriptors} from 'vrf'

export default {
  extends: descriptors.base,
  methods: {
    ... // some logic mutating data on the server
    invalidate(){
      this.$form.reloadResource(this.name)
    }
  }
}

```


## Actions

Vrf provides its own way to create simple buttons that activate async requests. These requests are served by middleware and the received data stored in the context of the form(by analogy with a resource).

For example, this snippet renders a button that initiates POST request to /archive in a resource context. 
```vue
<rf-action name="archive" />
```

You may change requests parameters by props

```vue
<rf-action 
  name="archive"
  method="put"
  :data="{force: true}"
  :params="{queryParameter: 1}"
/>
```

```rf-action``` in adapters may handle pending status by loader showing. Moreover, you can implement your own ```rf-action``` view using activator slot

```vue

<rf-action name="archive">
  <template v-slot:activator="{on, pending, humanName}">
    <my-great-button v-on="on" :loading="pending">{{humanName}}</my-great-button>
  </template>
</rf-action>

```

To render the results, in simple cases you can use ```rf-action-result``` component(with slot or component).

```vue
<rf-action name="loadText" />

<rf-action-result name="loadText" component="some-component-with-data-and-or-status-props" />

<rf-action-result name="loadtext">
  <template v-slot="{data}">
    <p>{{data}}></p>
  </template>
</rf-action-result>
```

Or/and use event ```result```

```vue

<rf-action name="doSomething" @result="onResult" />
```

If you need reload resource on result, you may use prop ```reload-on-result```

```vue

<rf-action name="switchMode" reload-on-result />

```

If your action must show toast in UI by result, this can be done in the middleware. For example, in REST middleware $message field will be processed by middleware as a message for user and it will be shown by ```showErrorMessage``` / ```showSuccessMessage``` functions(passed on vrf initialization).


### Run actions programmatically

You may run actions programmatically as well

```vue

<template>

<rf-form name="Todo" auto>
  ...
</rf-form>

</template>

<script>
export default {
  methods: {
    attachImage() {
      const data = new FormData()
      this.$form.executeAction('attachImage', {data, method: 'PUT'})
    }
  }
}
</script>

```

## Bitwise fields

Sometimes you need to manage some bitwise values in your resource. There is ```rf-bitwise``` component to manage them. It has two modes -
you can use this component as a wrapper for checkboxes, or use its ```options``` property(like ```rf-select```). It supports ```inverted``` mode as well.

```vue
<template>

<rf-form :resource="todo">

  <!-- rf-bitwise as wrapper, markup mode -->
  <rf-bitwise name="flags">
    <rf-checkbox name="visible" power="0" />
    <rf-checkbox name="editable" power="1" />
    <rf-checkbox name="shareable" power="2" />
  </rf-bitwise>

  <!-- rf-bitwise renders checkboxes itself by options -->
  <rf-bitwise
    name="flags"
    :options="options"
  />
</rf-form>

</template>

<script>

export default {
  data(){
    return {
      resource: {
        flags: 0
      }
    }
  },
  computed: {
    options(){
      return [
        {
          id: 0,
          name: 'visible' // use title instead of name, if you don't need translations
        },
        {
          id: 1,
          name: 'editable'
        },
        {
          id: 2,
          name: 'shareable'
        }
      ]
    }
  }
}


</script>

</template>

```


# Advanced

## Architecture

Vrf is all about modularity, you may customize almost any part of it. The final result is achieved due to symbiosis of the following components:

* Core(this package) - contains all business logic of forms. It implements form based on standard html components, without any styling and it's the foundation providing APIs for other modules.

* Adapters - implements VRF using some ui framework over link components descriptors from core. Most likely you will use vrf with some adapter.

* Translate lambda - function with ```(modelProperty, modelName) -> translation``` signature, used for translations

* Middlewares - components containing autoforms logic

* Autocomplete providers - components containing autocompletes logic

## Middleware API

Vrf creates an instance of middleware during form initialization. There are some middleware instance methods you neeed to implement:

* ```load``` - return Promise that resolves with resource
* ```loadSources``` - this method is called when form is mounted and ready to eager load all sources for rendered components. It resolves with object where keys are source names and values are collections.
* ```loadSource``` - it's called when some component need to require one source after eager loading and resolves with collection for this source
* ```save``` - used to save form resource

```javascript

export default class FooMiddleware {
  constructor(name, form){
    this.name = name
    this.form = form
  }

  static accepts({name, api, namespace}){ // determines if middleware is applicable for a given form
    return true
  }

  load(){
    return Promise.resolve({})
  }

  loadSource(name) {
    return Promise.resolve([])
  }
  
  loadSources(names){
    return Promise.resolve({})
  }
  
  save(resource){
    return Promise.resolve()
  }
}

const middlewares = [
  FooMiddleware
]

Vue.use(Vrf, {middlewares})

```

## Adapter API


The adapter must export the added components, it can both override components from the vrf, and add new ones(with ```rf-``` prefix).

```javascript

export default {
  name: 'vrf-adapter-name',
  components: {
    RfInput
    ...
  }
}
```

If you need install hook, you can add it, but you should be aware that it does not receive options, since  they refer to vrf. If you want options, you need to export an adapter factory instead of an adapter.

```javascript

export default (options) => {
  name: 'vrf-adapter-name',
  components: {
    RfInput
    ...
  },
  install(Vue){
  }
}
```

One of the main things to consider when writing an adapter is that your adapter should not have a dependency vrf or a ui framework that you are wrapping(you must include them only in dev and peer dependencies). Following this rule will avoid duplication of dependencies in the final product.

For this reason, instead of importing the parent descriptor from vrf (which is only valid in the final product), you need to use the vrfParent key in your component.

```vue
<template>

<input type="text" v-model="$value" />

</template>

<script>

export default {
  vrfParent: 'input'
}

</script>
```

If you need a basic implementation of element from core - use ```$vrfParent```

```vue

<template>

<button @onClick="onClick" v-if="someCondition">{{humanName}}</button>
<component :is="$vrfParent" v-else />

</template>

<script>

export default {
  vrfParent: 'action',
  computed: {
    someCondition() {
      ...
    }
  }
}

</script>

```




# Props
<table>
    <thead>
        <tr>
            <th>Prop</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
          <td colspan="2">
            All form inputs
          </td>
        </tr>
        <tr>
            <td>name</td>
            <td>Name of resource property</td>
        </tr>
        <tr>
            <td>disabled</td>
            <td>Prohibits editing content</td>
        </tr>
        <tr>
            <td>placeholder</td>
            <td>Placeholder</td>
        </tr>
        <tr>
            <td>label</td>
            <td>Overrides standard translation value for label.</td>
        </tr>
        <tr>
            <td>no-label</td>
            <td>Hides label </td>
        </tr>
        <tr>
            <td>required</td>
            <td>Mark field as required</td>
        </tr>
        <tr>
          <td colspan="2">
            rf-input
          </td>
        </tr>
        <tr>
            <td>transform</td>
            <td>Input formatting function</td>
        </tr>
        <tr>
          <td colspan="2">
            rf-checkbox, rf-switch
          </td>
        </tr>
        <tr>
            <td>inverted</td>
            <td>inverts the value of input</td>
        </tr>
    </tbody>

</table>

# Adapters
- [vrf-vuetify](https://github.com/dimailn/vrf-vuetify) - adapter for Vuetify.
- [vrf-tiny-mce](https://github.com/dimailn/vrf-tiny-mce) - adapter for Tiny MCE.

# Middlewares
- [vrf-rest](https://github.com/dimailn/vrf-rest) - REST middleware.

## Planned

* ```rf-radio```
* Clientside validations
>










