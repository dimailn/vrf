'use strict'
const utils = require('./utils')
const config = require('../config')
const isProduction = process.env.NODE_ENV === 'production'
const sourceMapEnabled = isProduction
  ? config.build.productionSourceMap
  : config.dev.cssSourceMap

const babelLoader = {
  loader: 'babel-loader',
  options: {
  }
}

module.exports = {
  // loaders: {
  //   ...utils.cssLoaders({
  //         sourceMap: sourceMapEnabled,
  //         extract: isProduction
  //       }),
  //   coffee: 'babel-loader?!coffee-loader',
  //   js: babelLoader
  // },
  cssSourceMap: sourceMapEnabled,
  cacheBusting: config.dev.cacheBusting,
  transformToRequire: {
    video: ['src', 'poster'],
    source: 'src',
    img: 'src',
    image: 'xlink:href'
  }
}
