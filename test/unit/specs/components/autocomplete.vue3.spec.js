import autocomplete from '@/components/descriptors/autocomplete'

const flushPromises = () => new Promise((resolve) => setTimeout(resolve, 0))

const deferred = () => {
  let resolve
  const promise = new Promise((promiseResolve) => {
    resolve = promiseResolve
  })

  return { promise, resolve }
}

const createVm = (overrides = {}) => {
  const vm = {
    entity: 'suggest/address',
    active: true,
    query: '',
    limit: undefined,
    loading: false,
    items: [],
    menu: false,
    $idKey: 'value',
    $queryKey: 'value',
    $value: null,
    $emit: jest.fn(),
    executeEvent: jest.fn(),
    instantLoad: jest.fn(),
    ...overrides
  }

  vm.cancelPendingLoad = autocomplete.methods.cancelPendingLoad.bind(vm)
  autocomplete.created.call(vm)

  return vm
}

describe('autocomplete descriptor in Vue 3', () => {
  afterEach(() => {
    jest.clearAllTimers()
    jest.useRealTimers()
  })

  it('не заменяет актуальные подсказки запоздавшим ответом', () => {
    const firstRequest = deferred()
    const secondRequest = deferred()
    const vm = createVm({
      query: 'Семеновская',
      executeEvent: jest
        .fn()
        .mockReturnValueOnce(firstRequest.promise)
        .mockReturnValueOnce(secondRequest.promise)
    })

    autocomplete.methods.instantLoad.call(vm)
    vm.query = 'Семеновская пл 3'
    autocomplete.methods.instantLoad.call(vm)

    const actualItems = [{ value: 'Москва, Семеновская площадь, 3' }]
    secondRequest.resolve(actualItems)

    return flushPromises()
      .then(() => {
        expect(vm.items).toEqual(actualItems)
        firstRequest.resolve([{ value: 'Москва, Семеновская площадь' }])
        return flushPromises()
      })
      .then(() => {
        expect(vm.items).toEqual(actualItems)
      })
  })

  it('сохраняет индикатор загрузки до завершения актуального запроса', () => {
    const firstRequest = deferred()
    const secondRequest = deferred()
    const vm = createVm({
      executeEvent: jest
        .fn()
        .mockReturnValueOnce(firstRequest.promise)
        .mockReturnValueOnce(secondRequest.promise)
    })

    autocomplete.methods.instantLoad.call(vm)
    autocomplete.methods.instantLoad.call(vm)

    return flushPromises()
      .then(() => {
        expect(vm.loading).toBe(true)
        secondRequest.resolve([])
        return flushPromises()
      })
      .then(() => {
        expect(vm.loading).toBe(false)
      })
  })

  it('не запускает отложенный поиск после выбора подсказки', () => {
    jest.useFakeTimers()
    const vm = createVm({
      query: 'Семеновская',
      instantLoad: jest.fn()
    })

    autocomplete.methods.load.call(vm)
    autocomplete.methods.onSelect.call(vm, {
      value: 'Москва, Семеновская площадь, 3'
    })
    jest.advanceTimersByTime(400)

    expect(vm.instantLoad).not.toHaveBeenCalled()
    expect(vm.$value).toBe('Москва, Семеновская площадь, 3')
    expect(vm.query).toBe('Москва, Семеновская площадь, 3')
    expect(vm.menu).toBe(false)
  })

  it('не объединяет debounce разных экземпляров autocomplete', () => {
    jest.useFakeTimers()
    const firstVm = createVm({
      query: '7707',
      instantLoad: jest.fn()
    })
    const secondVm = createVm({
      query: 'Москва',
      instantLoad: jest.fn()
    })

    autocomplete.methods.load.call(firstVm)
    autocomplete.methods.load.call(secondVm)
    jest.advanceTimersByTime(400)

    expect(firstVm.instantLoad).toHaveBeenCalledTimes(1)
    expect(secondVm.instantLoad).toHaveBeenCalledTimes(1)
  })
})
