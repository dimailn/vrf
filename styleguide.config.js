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
  styleguideDir: 'docs'
}