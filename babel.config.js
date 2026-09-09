module.exports = {
  "presets": ["@babel/preset-env"],
  "plugins": [
    "@babel/plugin-proposal-object-rest-spread",
    "@babel/plugin-transform-classes"
  ],
  // Under Jest (NODE_ENV=test) target the running Node so async/await is left
  // native instead of being down-compiled to regenerator (which needs a
  // regeneratorRuntime global that isn't provided in the test env).
  "env": {
    "test": {
      "presets": [["@babel/preset-env", { "targets": { "node": "current" } }]]
    }
  }
}

