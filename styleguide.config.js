const {decamelize} = require('humps')

module.exports = {
  title: 'Vrf components API',
  webpackConfig: require('./build/webpack.base.conf'),
  sections: [
    {
      name: 'UI Components',
      // content: 'docs/ui.md',
      components: 'src/components/templates/[A-z]*.vue'
    }
  ],
  usageMode: 'expand',
  exampleMode: 'expand',
  getComponentPathLine(componentPath) {
    return ""
  },
  styleguideDir: 'docs',
  updateDocs(docs) {
    docs.props = docs.props?.map((props) => ({...props, name: decamelize(props.name, { separator: '-' })}))

    return docs
  }
}