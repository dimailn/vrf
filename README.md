<p align="center">
  <img width="166" height="115" src="https://raw.githubusercontent.com/dimailn/vrf/master/static/logo.png" alt="vrf logo">
</p>

<a href="https://github.com/dimailn/vrf/actions/workflows/node.js.yml"><img src="https://github.com/dimailn/vrf/actions/workflows/node.js.yml/badge.svg" /></a>
[![Coverage Status](https://coveralls.io/repos/github/dimailn/vrf/badge.svg?branch=master&kill_cache=1)](https://coveralls.io/github/dimailn/vrf?branch=master)
<a href="https://www.npmjs.com/package/vrf"><img alt="npm" src="https://img.shields.io/npm/v/vrf"></a>
<img src="https://img.shields.io/bundlephobia/min/vrf" />
<img src="https://img.shields.io/bundlephobia/minzip/vrf" />


<a href="https://dimailn.github.io/vrf-demo.github.io">Live demo</a>

<a href="https://dimailn.github.io/vrf">Documentation</a>


# Build Setup

``` bash
# install dependencies
npm install

# start playground
npm start
```

# Vrf installation

Vue 2

```bash
npm install --save vrf
```

```javascript
import Vue from 'vue'
import Vrf from 'vrf'

Vue.use(Vrf)

```


Vue 3 (experimental build)

```bash
npm install --save vrf@next
```

```javascript
import {createApp} from 'vue'
import Vrf from 'vrf'

createApp(...)
  .use(Vrf)
  .mount(...)

```


# Table of contents

- [What is vrf?](#what-is-vrf)
- [Ideology](#ideology)
- [What does it look like?](#what-does-it-look-like)
- [Basics](#basics)
  - [Object binding](#object-binding)
  - [Access to the resource](#access-to-the-resource)
  - [Where is the resource?](#where-is-the-resource)
  - [Expressions](#expressions)
  - [Sources](#sources)
  - [Groups](#groups)
  - [Scopes](#scopes)
  - [Nested entities](#nested-entities)
  - [Autoforms](#autoforms)
  - [Data loading control](#data-loading-control)
  - [Actions](#actions)
    - [Run actions programmatically](#run-actions-programmatically)
  - [Default props](#default-props)
  - [v-model](#v-model)
- [Advanced](#advanced)
  - [Architecture](#architecture)
  - [Effects API](#effects-api)
  - [Autocomplete API](#autocomplete-api)
  - [Adapter API](#adapter-api)


 

# What is vrf?

Vrf is an abstraction over
* UI, because it is a set of components' interfaces that should be implemented in adapters
* Network, because you operate only with terms of the subject area and business actions in application code, and the implementation is delegated to effects
* I18n, because you can plug in any i18n library(but vue-i18n is supported from the box)
* Any other areas related to forms, like validations, notifications and analytics, that should be decoupled into plugins, using Effects API

# Ideology

Vrf puts form at the forefront of your application, but at the same time all high-level features are provided unobtrusively and their activation is implemented explicitly.  The main thesis of vrf is to stay simple while it is possible.  This means, for example, that you can make the most of the built-in auto-forming capabilities without having to write any code, but if one day you need a more complex flow than effects can offer, you can simply turn off the auto mode and manually manipulate the form, while still taking the other advantages that  vrf gives.

In other words, the complex things have the right to be complex, but simple should remain simple.

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


Such form will load and save data without a single line of Javascript code. This is possible due to the use of the effects, which describes the general logic of working with entities in your project. If a form requires very specific logic, that form can be used in a lower-level mode(without the "auto" flag).

## Features

* expressive syntax
* ease of separation
* I18n
* Validations(as interface)
* autoforms
* nested entities
* option ```disabled``` / ```readonly``` for entire form
* vuex integration
* unlimited extension using Effects API

# Basics

 ## Object binding

The cornerstone of vrf is the binding to an object. This concept assumes that instead of defining a v-model for a field each time, you do a binding once — entirely on the form object, and simply inform each component of the form what the name of the field to which it is attached is called.  Due to this knowledge, the form can take on the tasks of internationalization and display of validations (whereas when determining the v-model for each field, you are forced to do it yourself).

```vue
<template>

<rf-form v-model="resource" :errors="errors">
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
         title: ['Should not be empty']
       }
    }
  }
}


</script>
```

## Access to the resource

The form passes a reactive context to all child components (using the Provide / Inject API), so any descendant of that form (not even direct) can receive this data.  This allows you to break complex forms into several parts, however, in most cases it is recommended to keep the form in one file.

There are several ways to access the resource:

* use rf-resource component

```vue
<rf-resource v-slot="{$resource}">
  <div>{{$resource}}</div>
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
* in the state of form(this happens in auto forms, or for example, if you do not pass a ```resource``` prop). In this case, you can get a reference to the resource using ```:resource.sync``` prop.
* in vuex

## Expressions

The standard way of writing expressions that depend on the resource is the use ```$resource``` variable from the scoped slot on ```rf-form``` in the main form file

```vue

<rf-form
  name="Todo"
  v-slot="{$resource}"
>
  <rf-input name="title" :disabled="$resource.id" />
</rf-form>

```

It won't fail if ```$resource``` is not loaded yet, because the scoped slot is rendered only after ```$resource``` is loaded. All required sources are initialized using empty arrays, so using ```$sources``` reference is also safe.

If your form is split into files and you need conditional rendering in the file without ```rf-form``` - you should use ```rf-resource``` component to access the resource.



## Sources

Some components (such as selects) require options for their work.  The form
```sources``` property is used for this purpose. It expects a hash of all the necessary options which can be accessed in specific components by name.

```vue

<template>

<rf-form v-model="resource" :sources="sources">
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
Instead of a string with the name of the options, you can also directly pass an array of options(but it is used less often since vrf's strength is precisely the declarative descriptions of forms and auto forms can load sources by name).

When you use a source name with auto forms, the form uses effects to load the collection for a source. Internally, this is achieved by calling the method ```requireSource``` on the form when the component is mounted or the```options``` prop is updated. Then the form chooses the most effective loading strategy depending on the stage at which the method ```requireSource``` was called. You may use this method in your own components when you need sources for their work.


## Groups

Vrf contains ```rf-group``` component that is used for grouping descendants from ```descriptors.groupItem```, like ```rf-checkbox```, ```rf-radio```, or any custom descendant. 

Outside of a group, groupItem components work like boolean selection:

```vue

<template>

<rf-form v-model="resource">
  <rf-checkbox name="isActive" />
</rf-form>
 
</template>

<script>

export default {
  data() {
    return {
      resource: {
        isActive: false
      }
    }
  }
}

</script>
```

But inside they are used to choose value:

```vue

<template>

<rf-form v-model="resource">
  <rf-group name="mode">
    <rf-checkbox name="read" />
    <rf-checkbox name="write" />
  </rf-group>
</rf-form>
 
</template>

<script>

export default {
  data() {
    return {
      resource: {
        mode: 'read'
      }
    }
  }
}

</script>
```

Choose multiple value:

```vue

<template>

<rf-form v-model="resource">
  <rf-group name="modes" multiple>
    <rf-checkbox name="read" />
    <rf-checkbox name="write" />
  </rf-group>
</rf-form>
 
</template>

<script>

export default {
  data() {
    return {
      resource: {
        modes: ['read', 'write']
      }
    }
  }
}

</script>
```

Also, you can use the ```inverted``` property on ```rf-group``` to invert the behaviour.

The group supports ```options``` prop, you can pass an array and use any descendant of ```descriptors.groupItem``` as ```item-component```(```rf-radio``` is used by default)h
```vue
<rf-form v-model="resource">
  <!-- also you  can specify id-key and title-key -->
  <rf-group 
    name="mode" 
    :options="modes"
    item-component="rf-checkbox"
    multiple 
  />
</rf-form>
 
</template>

<script>

export default {
  data() {
    return {
      resource: {
        mode: ['read', 'write']
      },
      modes: [
        {
          id: 'read',
          title: 'Read'
        },
        {
          id: 'write',
          title: 'Write'
        }
      ]
    }
  }
}

</script>
```


Moreover, sometimes you need to manage some bitwise values in your resource. Groups allow you to manage them. It has two modes -
either you can use this component as a wrapper for items, or you can use its ```options``` property. It supports ```inverted``` mode as well.

```vue
<template>

<rf-form v-model="resource">

  <!-- markup mode -->
  <rf-group name="flags" bitwise multiple>
    <!-- value is a power -->
    <rf-checkbox name="visible" value="0" />
    <rf-checkbox name="editable" value="1" />
    <rf-checkbox name="shareable" value="2" />
  </rf-group>

  <!-- rf-bitwise is an alias for rf-group with set bitwise and multiple flags -->
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

## Scopes

There is ```rf-scope``` component that helps you to break your form by logical scopes.

For example, if you need to disable only part of a form, it'll look like

```vue

<rf-form name="User">
  <rf-input name="name" />
  
  <rf-scope :disabled="!isAdmin">
    <rf-checkbox name="readPermission" />
    <rf-checkbox name="writePermission" />
   </rf-scope>
   
   <rf-submit />
</rf-form>
```

The scope may be submitted separately as a slice of fields which are inside the scope when you use ```isolated``` mode

```vue
<rf-form name="User">
  <rf-input name="name" />
  
  <rf-scope isolated>
    <rf-input name="token"/>
    
    <rf-submit /> <!-- this submit sends only { token: '...' } object -->
   </rf-scope>
   
   <rf-submit />
</rf-form>
```

You also can trigger submit if data is changed inside the scope with property ```autosave```

```vue
<rf-form name="User">
  <rf-input name="name" />
  
  <rf-scope isolated autosave>
    <rf-switch name="blocked" />
   <rf-scope />
   
   <rf-submit />
</rf-form>
```



## Nested entities
Vrf supports work with nested entities, both single and with collections. The ```rf-nested``` component is used to work with them, which expects a scoped slot with form components for a nested entity. Internally, ```rf-nested``` uses the ```rf-form``` the required number of times, so the use of rf-nested can be equated with the declaration of the form inside the form, which can be duplicated if necessary.

```vue
<template>

<rf-form v-model="resource">
  <rf-input name="title" />
  <rf-nested name="subtasks"> // you may specify translation-name for nested scope, by default it will be singularized name
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

Autoforms are a special form mode in which the form within itself performs tasks of loading, saving data, forwarding validation errors and can also perform some side effects, for example, redirecting to a page of a newly created entity.

Autoforms are powered by Effects API which allows the creation of plugins in modular way. Due to this, it is possible to implement the flow of autoforms for the specifics of any project. You may use ready-made effects or implement your own.


## Data loading control

Vrf provides some methods on rf-form allows you to manage data loading:

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

Vrf provides a way to create simple buttons that activate async requests. These requests are served by effects and the received data is stored in the context of the form(by analogy with a resource).

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
  <template v-slot:activator="{on, pending, label}">
    <my-great-button v-on="on" :loading="pending">{{label}}</my-great-button>
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

If your action must show toast in UI by result, this can be done in the effects. For example, in REST effect $message field will be processed by effect as a message for the user and it will be emitted by ```showMessage```.


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


## Default props

You may specify default props values for some inputs globally during vrf initialization. It allows you to set up common styles for ui framework if it uses props for customization.

```javascript
Vue.use(Vrf, {
  adapters: [
    VrfVuetify
  ],
  defaultProps: {
    RfInput: {
      outlined: true
    }
  }
})
```

## v-model

In some cases you may want to use ```rf-``` controls outside of the form, if you don't need the form functionality, but still want to use the same elements without separating vrf/non-vrf inputs. Regarding this, vrf inputs support ```v-model``` directive, allowing for them to be used in a seamless way

```vue
<template>

<div>
  <p>Enter your first name</p>
  <rf-input v-model="firstName" />
</div>

</template>


<script>

export default {
  data(){
    return {
      firstName: ''
    }
  }
}

</script>


```

# Advanced

## Architecture

Vrf is all about modularity, you may customize almost any part of it. The final result is achieved due to symbiosis of the following components:

* Core(this package) - contains all business logic of forms. It implements form based on standard html components, without any styling and it's the foundation providing APIs for other modules.

* Adapters - implements vrf using some ui framework over link components descriptors from core. Most likely you will use vrf with some adapter.

* Translate lambda - function with ```(modelProperty, modelName) -> translation``` signature, used for translations

* Effects - autoforms logic and side effects

* Autocomplete providers - components containing autocompletes logic

## Effects API

Vrf uses effects to deal with auto-forms lifecycle and side effects. There are two types of effects - API and non-API effects.

API effects:
* activated by the ```auto``` property of the ```rf-form```
* executed for each event in order of registration in ```Vue.use(Vrf, {effects: [...]})``` until some effect returns promise(this mechanic works only on ```onLoad```, ```onLoadSources```, ```onLoadSource```, ```onSave```, ```onCreate``` and ```onUpdate``` subscriptions)
* it's possible to choose effect by specify its name in ```auto``` property of the ```rf-form```
* by passing ```EffectExecutor``` to ```auto``` property you may customize autoform logic ad-hoc

non-API effects:
* activated by the ```effects``` property of the ```rf-form```
* executed for each event in order of registration
* it's possible to specify effects for current form by passing array of names to the ```effects``` property

### Effect definition and using

There are type definitions for more convenient developing effects. If you create a plugin, you should export an effect factory with default options to provide simple way to add new options in the future.

```typescript

// effect.ts
import {Effect} from 'vrf'

export default (options = {}) : Effect => {
  return{
    name: 'effect-name',
    api: true,
    effect({onLoad, onLoadSource, onLoadSources, onSave, }){
      onLoad((id) => Promise.resolve({}))

      onLoadSource((name) => Promise.resolve([]))

      onLoadSources((names) => Promise.resolve({}))

      onSave((resource) => Promise.resolve())
    }
  }
}


// initialization of vrf in project

import effect from './effect'

const effects = [
  effect()
]

Vue.use(Vrf, {effects})

```

### Lifecycle

Effects are mounted after ```auto```/```effects``` props changing and initially after form mounting. There are two effect lifecycle events:

* ```onMounted``` - is fired on each effect mounting
* ```onUnmounted``` - is fired on each effect unmounting(when managing props are changed or form is destroyed). This subscription should be used to clear some stuff, for example some side event listeners.

### API effects

There are some subscriptions for api effects:

* ```onLoad``` - is fired when form loads the resource
* ```onLoadSources``` - is fired when form loads the sources in eager way
* ```onLoadSource``` - is fired when form loads only one source because of ```form.requireSource``` execution. It happens for example if ```rf-select``` appeared as a result of condition rendering
* ```onSave``` - is fired when form is submitted. It is optional subscription, instead you may use more convenient ```onCreate``` and ```onUpdate``` subscriptions.
* ```onCreate``` - is fired when form creates new resource
* ```onUpdate``` - is fire when form updates new resource
* ```onCreated``` - is fired when ```onCreate``` returned an id of new created resource. There is a default trap for this event, which reloads form data, but it's possible to override this behaviour by using ```event.stopPropagation()```
* ```onLoaded``` - is fired when data is received from backend, the same like ```after-load-success``` on the form
* ```onSuccess``` - is fired when resource is saved successfully
* ```onFailure``` - is fired when resource wasn't saved due to errors

### Validations

* ```onValidate``` - is fired before saving process, stops saving if any listeners returns ```false```


### Data converters

You may implement data convertation after receiving resource from api effect and before sending. For this purpose Effects API has two subscriptions:

* ```onAfterLoad``` - is fired each time when vrf received entities from api effect(for resource and for each entity of sources)
* ```onBeforeSave``` - is fired before resource will be saved

The listeners of these events are just mappers, which get object and return modified object. It's possible to use many converters in your application, they will be executed in the order of registrations in ```effects``` section. Converters should use ```api: true``` flag, because they should be executed always when ```auto``` is enabled.

### User notifications

There is a standard way to provide user notification customization using ```onShowMessage``` subscription. So, you may use ```showMessage``` helper to emit message from any effect using type definitions from vrf, and any notifications effect which uses ```onShowMessage``` subscription will be able to show this notification.

## Autocomplete API

The component ```rf-autocomplete``` is designed to be reusable through providers that contain the logic of fetching/initializing data and any custom functionalities, like special row for creating new resources and so on.

The definition of autocomplete provider is quite similar to an effect definition:

```javascript

// vrf-search.js
export default () => ({
  name: 'search',
  setup({
    onLoad,
    onMounted,
    onValueChanged
  }) {
    onLoad(async ({query}) => {
      const items = await ...
      
      return items
    })
    
    onMounted(() => {
      // onMounted logic, if you need
    })
    
    onValueChanged(() => {
      // onValueChanged logic, if you need
    })
  }
})
```

Using as a global plugin

```javascript
import vrfSearch from './vrf-search'

Vue.use(Vrf, {
  autocompletes: [
    vrfSearch()  
  ]
})

```

```vue
<rf-autocomplete name="title" type="search" title-key="title" />
```

or ad-hoc

```vue
<template>

<rf-autocomplete name="title" :type="search" title-key="title" />

</template>

<script>
import vrfSearch from './vrf-search'

export default {
  computed: {
    search: vrfSearch()
  }
}

</script>
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

One of the main things to consider when writing an adapter is that your adapter should not have vrf or a wrapped ui framework dependency in your bundle(you must include them only in dev and peer dependencies). Following this rule will avoid duplication of dependencies in the final product. To achieve this, you need to set up your bundler to handle vrf as external dependency and import descriptor in usual way.

```vue
<template>

<input type="text" v-model="$value" />

</template>

<script>
import {descriptors} from 'vrf'

export default {
  extends: descriptors.input
}

</script>
```

If you need a basic implementation of element from core - use ```$vrfParent```

```vue

<template>

<button @onClick="onClick" v-if="someCondition">{{$label}}</button>
<component :is="$vrfParent" v-else />

</template>

<script>
import {descriptors} from 'vrf'

export default {
  extends: descriptors.action,
  computed: {
    someCondition() {
      ...
    }
  }
}

</script>

```

After all, add your adapter to vrf

```javascript

import VrfAdapterName from './vrf-adapter-name'

Vue.use(Vrf, {
  adapters: [
    VrfAdapterName
  ]
})
```


# Adapters
- [vrf-vuetify](https://github.com/dimailn/vrf-vuetify) - adapter for Vuetify.
- [vrf-tiny-mce](https://github.com/dimailn/vrf-tiny-mce) - adapter for Tiny MCE.

# Effects
- [vrf-rest](https://github.com/dimailn/vrf-rest)
- [vrf-redirect](https://github.com/dimailn/vrf-redirect)
- [vrf-date-converter](https://github.com/dimailn/vrf-date-converter)











