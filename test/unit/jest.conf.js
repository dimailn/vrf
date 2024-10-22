const path = require('path')

module.exports = {
  rootDir: path.resolve(__dirname, '../../'),
  moduleFileExtensions: [
    'js',
    'json',
    'vue',
    'coffee',
    'ts'
  ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  },
  transform: {
    '^.+\\.js$': 'babel-jest',
    '.*\\.(vue)$': '@vue/vue3-jest',
    "^.+\\.coffee$": "coffee-jest",
    '^.+\\.ts$': 'ts-jest'
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
     "<rootDir>/src/components/descriptors",
     "<rootDir>/src/utils/set.js"
  ],
  globals: {
    'ts-jest': {
      isolatedModules: true
    },
  },
  testRunner: 'jest-jasmine2',
  testEnvironment: "jsdom"
}
