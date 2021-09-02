const path = require('path')

module.exports = {
  rootDir: path.resolve(__dirname, '../../'),
  moduleFileExtensions: [
    'js',
    'json',
    'vue',
    'coffee'
  ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  },
  transform: {
    '^.+\\.js$': 'babel-jest',
    '.*\\.(vue)$': 'vue-jest',
    "^.+\\.coffee$": "coffee-jest"
  },
  modulePaths: ['<rootDir>/src'],
  testPathIgnorePatterns: [
    '<rootDir>/test/e2e'
  ],
  snapshotSerializers: ['<rootDir>/node_modules/jest-serializer-vue'],
  setupFilesAfterEnv: ['<rootDir>/test/unit/jest.setup'],
  verbose: true,
  testURL: "http://localhost/",
  testMatch: [
    "**/specs/**/*.spec.coffee"
  ],
  coveragePathIgnorePatterns: [
     "<rootDir>/src/components/descriptors"
  ]
}
