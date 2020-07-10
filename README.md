# What is VRF?

Vue Resource Form is a solution for quickly writing declarative user interface forms.


First of all VRF is the specification of form components. The are so many great ui frameworks with different components API, so if you want migrate from one to other you will must to refactor each form and probably, it isn't you want. VRF provides common abstract standard for forms like pure html forms, but more powerful.

This package contains a set of descriptors for each form element that you can use to create your own implementation.  If you need to add a new property/feature to some component - this is probably an occasion to think about whether it is possible to add it to the core (this can be discussed in issues).  If the it can be added to the core, this will mean that it is included in the standard and all authors of other implementations will also be able to implement it.

VRF doesn't depends on current I18n, validation and network interaction libraries. Instead, it provides interfaces for integration with any one.


Such form will load and save data without a single line of Javascript code. This is possible due to the use of the middleware, which describes the general logic of working with entities in your project. If some form required very specific logic, the form can be used in a lower level mode(without "auto" flag).

## What does it look like?

It allows you to write forms in this way:

```vue
<rf-form rf-name="User" auto>
  <rf-input name="firstName" />
  <rf-input name="lastName" />
  <rf-switch name="blocked" />
  <rf-select-id name="roleId" options="roles" />
  <rf-textarea name="comment" />
  <rf-submit>Save</rf-submit>
</rf-form>

```
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

## Build Setup

``` bash
# install dependencies
npm install

# start playground
npm start
```


# Architecture

* Core(this package) - contains all business logic of forms. It implements form based on standard html components, without any styling. 

* Adapters - implements VRF using some ui framework over import components descriptors from core.

* Translate lambda - function with ```(modelProperty, modelName) -> translation``` signature, used for translations

* Middlewares - components containing autoforms logic

* Autocomplete providers - components containing autocompletes logic













