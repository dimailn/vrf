# Build Setup

``` bash
# install dependencies
npm install

# start playground
npm start
```

# What is VRF?

Vue Resource Form is a solution for quickly writing declarative user interface forms.


First of all VRF is the specification of form components. The are so many great ui frameworks with different components API, so if you want migrate from one to other you will must to refactor each form and probably, it isn't you want. VRF provides common abstract standard for forms like pure html forms, but more powerful.

This package contains a set of descriptors for each form element that you can use to create your own implementation.  If you need to add a new property/feature to some component - this is probably an occasion to think about whether it is possible to add it to the core (this can be discussed in issues).  If the it can be added to the core, this will mean that it is included in the standard and all authors of other implementations will also be able to implement it.

VRF doesn't depends on current I18n, validation and network interaction libraries. Instead, it provides interfaces for integration with any one.


## What does it look like?

It allows you to write forms in this way:

```vue
<rf-form rf-name="User" auto>
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
* option disabled for form
* vuex integration

## Planned

* Clientside validations
>


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
  <template slot-scope="props">
    <div>{{props.resource}}</div>
  </template>
</rf-resource>
```

* use Resource mixin

```vue

<template>

<div>
  {{resource}}
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
  <input v-model="value" />
  {{resource}}
</div>
</template>

<script>

import {descriptors} from 'vrf'

export default {
  extends: descriptors.input
}

</script>
```

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

# Architecture

* Core(this package) - contains all business logic of forms. It implements form based on standard html components, without any styling. 

* Adapters - implements VRF using some ui framework over import components descriptors from core.

* Translate lambda - function with ```(modelProperty, modelName) -> translation``` signature, used for translations

* Middlewares - components containing autoforms logic

* Autocomplete providers - components containing autocompletes logic












