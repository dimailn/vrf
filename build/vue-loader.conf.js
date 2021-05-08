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
      // console.log(directiveMeta)
      // console.log(node)
      // console.log(node.parent.children[0].ifConditions)


      const {arg, value} = directiveMeta

      switch(arg) {
        case 'v-else':
          console.log(node)
          console.log(node.parent, 'aprent')

          const nodeIndex = node.parent.children.findIndex((someNode) => someNode === node)
          console.log(nodeIndex)
          console.log(nodeIndex)

          let newParentRoot = null
          let offset = -1

          while((newParentRoot = node.parent.children[nodeIndex + offset]).type != 1)
            offset -= 1

          console.log(newParentRoot)
          const newParent = newParentRoot.scopedSlots['"default"']

          const sibling = newParent.children[0]
          console.log(sibling)
          sibling.ifConditions.push(node)

          node.parent = sibling.parent

          node.else = true
          node.attrsMap['v-else'] = ''

          node.parent.children = node.parent.children.filter((someNode) => someNode !== node)

          console.log(node)

        break;

        case 'v-if':
          const copyOfNode = {...node}

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

          node.attrsList = []
          node.directives = []
          node.attrsMap = {}

          copyOfNode.directives = copyOfNode.directives.filter((innerDirective) => innerDirective !== directiveMeta)
          copyOfNode.attrsList = [copyOfNode.attrsList.filter((attr) => !/v-rf/.test(attr.name))]


          Object.keys(copyOfNode.attrsMap).forEach((attrKey) => /v-rf/.test(attrKey) && (delete copyOfNode.attrsMap[attrKey]))

          const exp = [
            "resource",
            "sources",
            "rootResource",
            "errors"
          ].reduce((exp, propName) => exp.replace(new RegExp("\\$" + propName, 'g'), `props.${propName}`), value)

          copyOfNode.if = exp
          copyOfNode.ifConditions = [
            {
              exp,
              block: copyOfNode
            }
          ]

          copyOfNode.attrsMap['v-if'] = exp
        break;
      }
    }
  }
}
