// import RfFormComponent from '../components/descriptors/form'

// type RfForm = InstanceType<typeof RfFormComponent>


type OnLoadResult = any

interface ExecuteActionOptions {
    params?: object
    data?: any
    method?: string
    url?: string
}

export interface Event<T> {
  payload: T
  eventName: string
  stopPropagation: () => void
}

type EffectCustomEvent = Event<any>

type Id = number | string

export interface Message {
  text: string
  type?: 'success' | 'error' | 'info'
}

export interface EffectContextBuiltinListeners {
  onLoad: (listener: (id: Id) => Promise<OnLoadResult> | void) => void
  onSave: (listener: (resource: any) =>  Promise<object> | void) => void
  onCreate: (listener: (resource: any) => Promise<[boolean, Id]> | void) => void
  onCreated: (listener: (event: Event<{id: Id}>) => void) => void
  onUpdate: (listener: (resource: any) => Promise<[boolean, void | object]> | void) => void
  onLoadSource: (listener: (sourceName: string) => Promise<object> | void) => void
  onLoadSources: (listener: (sourceNames: Array<string>) => Promise<object> | void) => void
  onExecuteAction: (listener: (actionName: string, options: ExecuteActionOptions) => Promise<any> | void) => void
  onShowMessage: (listener: (event: Event<Message>) => void) => void
  onMounted: (listener: () => void) => void
  onUnmounted: (listener: () => void) => void
  onAfterLoad: (listener: (event: Event<{resource: any}>) => object) => void
  onBeforeSave: (listener: (event: Event<{resource: any}>) => object) => void
  onFailure: (listener: (event: Event<{errors: any}>) => object) => void
}

type EffectContext = {
  strings: {
    resourceName:  () => string
    urlResourceName: () => string
    urlResourceCollectionName: () => string
  }
  form: any
  showMessage: (message: Message) => void
} & EffectContextBuiltinListeners

export type EffectExecutor = (context: EffectContext) => void
export type Effect = {
    effect: EffectExecutor
    name: string
    api?: boolean
}


export type EffectListenerNames = keyof EffectContextBuiltinListeners

export type InstantiatedEffect = {
    listeners: {
        [EventName in EffectListenerNames]: Parameters<EffectContext[EventName]>[0]
    }
    customEventListeners: Record<string, Array<(event: Event<any>) => void>>
    api: boolean
}


const effect : EffectExecutor = ({
    onLoad,
    onExecuteAction,
    form
}) => {
    onExecuteAction((actionName, options) => {

    })
}