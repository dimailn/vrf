import camelCase from '../../../../src/utils/camel-case'
import dateInterceptor from '../../../../src/utils/date-interceptor'
import pick from '../../../../src/utils/pick'
import toPath from '../../../../src/utils/to-path'
import PathService from '../../../../src/types/path-service'

describe 'camelCase', ->
  it 'lowercases a single word', ->
    expect(camelCase('Hello')).toBe 'hello'

  it 'camel-cases multiple words', ->
    expect(camelCase('hello world')).toBe 'helloWorld'

  it 'handles snake_case', ->
    expect(camelCase('foo_bar_baz')).toBe 'fooBarBaz'

describe 'dateInterceptor', ->
  describe 'in', ->
    it 'parses a date string into a Date', ->
      result = dateInterceptor.in('2020-01-02T03:04')
      expect(result instanceof Date).toBe true

  describe 'out', ->
    it 'returns undefined for a falsy value', ->
      expect(dateInterceptor.out(null)).toBeUndefined()

    it 'formats single-digit month/day/time with leading zeros', ->
      date = new Date(2020, 0, 2, 3, 4)
      expect(dateInterceptor.out(date)).toBe '2020-01-02T03:04'

    it 'formats double-digit values without leading zeros', ->
      date = new Date(2020, 10, 25, 13, 45)
      expect(dateInterceptor.out(date)).toBe '2020-11-25T13:45'

describe 'pick', ->
  it 'picks the given keys from an object', ->
    expect(pick({ a: 1, b: 2, c: 3 }, ['a', 'c'])).toEqual { a: 1, c: 3 }

  it 'returns an empty object when source is null', ->
    expect(pick(null, ['a', 'b'])).toEqual {}

describe 'toPath', ->
  it 'joins string elements with dots', ->
    expect(toPath(['a', 'b', 'c'])).toBe 'a.b.c'

  it 'uses bracket notation for numeric elements', ->
    expect(toPath(['a', 0, 'b'])).toBe 'a[0].b'

  it 'keeps a leading numeric element as a bracket', ->
    expect(toPath([0, 'a'])).toBe '[0].a'

describe 'PathService', ->
  it 'adds a key at the root without a parent path', ->
    service = new PathService()
    service.add(null, 'foo')
    expect(service.root.foo).toEqual {}

  it 'adds a key under a parent path', ->
    service = new PathService()
    service.add(null, 'foo')
    service.add('foo', 'bar')
    expect(service.getRootByPath(['foo', 'bar'])).toEqual {}

  it 'returns the root for an empty path', ->
    service = new PathService()
    service.add(null, 'foo')
    expect(service.getRootByPath()).toBe service.root
