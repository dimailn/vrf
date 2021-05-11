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


const clearNode = (node) => {
  Object.keys(node).forEach((key) => delete node[key])
  node.type = 3
  node.text = ''
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
          // console.log(node)
          // console.log(node.parent, 'aprent')
          // console.log(node.parent.children.map((child) => child.ifConditions))

          // const nodeIndex = node.parent.children.findIndex((someNode) => someNode === node)
          // console.log(nodeIndex)

          // let newParentRoot = null
          // let offset = -1

          // while((newParentRoot = node.parent.children[nodeIndex + offset]).type != 1)
          //   offset -= 1

          // console.log(newParentRoot)
          // const newParent = newParentRoot.scopedSlots['"default"']

          // const sibling = newParent.children[0]

          // // sibling.ifConditions.push({exp: undefined, block: node})
          // console.log(sibling, 'sibling')


          // node.parent.children = node.parent.children.filter((someNode) => someNode !== node)

          // console.log(node.parent)

          // node.parent = null


          // node.parent = sibling.parent

          // sibling.parent.children.push(node)
          // sibling.ifProcessed = false

          // node.else = true
          // node.attrsMap['v-else'] = ''

          // Object.keys(node).forEach((key) => delete node[key])

          // node.if = 'false'
          // node.ifConditions = [{exp: 'false', block: node}]
          // node.attrsMap = {'v-if': 'false'}
          // console.log(node)



          // console.log(node)

        break;

        case 'v-if':
          console.log(node)
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
          node.attrs = []

          node.children = []

          node.tag = 'rf-resource'

          node.directives = []


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


          const elseNode = node.parent.children.find((someNode) => someNode.attrsMap && someNode.attrsMap['v-rf:v-else'] === '')
          const elseIfNodes = node.parent.children.filter((someNode) => someNode.attrsMap && someNode.attrsMap['v-rf:v-else-if'])

          elseIfNodes.forEach((elseIfNode) => {
            if(elseIfNode) {
              const directive = elseIfNode.directives.find((directive) => directive.name === 'rf')

              copyOfNode.ifConditions.push(
                {
                  exp: directive.value,
                  block: {...elseIfNode, elseif: directive.value, parent: undefined }
                }
              )

              clearNode(elseIfNode)
            }
          })

          if(elseNode) {
            copyOfNode.ifConditions.push(
              {
                exp: undefined,
                block: {...elseNode, else: true, parent: undefined}
              }
            )

            clearNode(elseNode)
          }



          copyOfNode.attrsMap['v-if'] = exp

        break;
      }
    }
  }
}
