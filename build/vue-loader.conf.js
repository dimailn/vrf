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
  loaders: {
    ...utils.cssLoaders({
          sourceMap: sourceMapEnabled,
          extract: isProduction
        }),
    coffee: 'babel-loader?!coffee-loader',
    js: babelLoader
  },
  cssSourceMap: sourceMapEnabled,
  cacheBusting: config.dev.cacheBusting,
  transformToRequire: {
    video: ['src', 'poster'],
    source: 'src',
    img: 'src',
    image: 'xlink:href'
  },
  compilerDirectives: {
    rf (node, directiveMeta) {
      const copyOfNode = {...node}

      console.log(copyOfNode)

      const template = {
        type: 1,
        tag: 'template',
        attrsList: [],
        attrsMap: {},
        rawAttrsMap: {},
        parent: node,
        children: [copyOfNode],
        slotTarget: '"default"',
        slotTargetDynamic: false,
        slotScope: 'props'
      }

      copyOfNode.parent = template

      node.scopedSlots =  {
        '"default"': template
      }

      node.attrsList = []
      node.attrsMap = {}
      node.rawAttrsMap = {}
      node.children = []

      node.tag = 'rf-resource'

      const directive = copyOfNode.directives.find((directive) => directive.name === 'rf')

      copyOfNode.directives = copyOfNode.directives.filter((innerDirective) => innerDirective !== directive)
      node.directives = copyOfNode.directives

      node.attrsList = node.attrsList.filter((attr) => !/v-rf/.test(attr.name))
      copyOfNode.attrsList = copyOfNode.attrsList.filter((attr) => !/v-rf/.test(attr.name))

      Object.keys(node.attrsMap).forEach((attrKey) => /v-rf/.test(attrKey) && (delete node.attrsMap[attrKey]))
      Object.keys(copyOfNode.attrsMap).forEach((attrKey) => /v-rf/.test(attrKey) && (delete copyOfNode.attrsMap[attrKey]))

      const {arg, value} = directive

      const exp = value.replace("$resource", "props.resource")

      copyOfNode.if = exp
      copyOfNode.ifConditions = [
        {
          exp,
          block: copyOfNode
        }
      ]
      // copyOfNode.ifProcessed = true
      copyOfNode.attrsMap['v-if'] = exp

  //       if: 'resource.title',
  // ifConditions: [ { exp: 'resource.title', block: [Circular *1] } ],


      // debugger
      // transform node based on directiveMeta
    }
  }
}
