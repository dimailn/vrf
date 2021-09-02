'use strict'
const merge = require('webpack-merge')

module.exports = {
  __VERSION__: `"${require("../package.json").version}"`,
  'process.env': {
    NODE_ENV: '"testing"'
  }
}
