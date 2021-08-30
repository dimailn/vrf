module.exports = {
  // components: 'src/components/templates/[A-z]*.vue',
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
}