'use strict'

module.exports = {
  __VERSION__: `"${require("../package.json").version}"`,
  'process.env': {
    NODE_ENV: '"development"'
  }
}
