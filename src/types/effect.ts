// import RfFormComponent from '../components/descriptors/form'

// type RfForm = InstanceType<typeof RfFormComponent>


type OnLoadResult = [boolean, object]

interface ExecuteActionOptions {
    params?: object
    data?: any
    method?: string
    url?: string
}

interface Event<T> {
  payload: T
  eventName: string
  stopPropagation: () => void
}

type EffectCustomEvent = Event<any>

type Id = number | string

export interface EffectContextBuiltinListeners {
  onLoad: (listener: (id: Id) => Promise<OnLoadResult> | void) => void
  onSave: (listener: () =>  Promise<object> | void) => void
  onCreate: (listener: () => Promise<[boolean, Id]> | void) => void
  onCreated: (listener: (event: Event<{id: Id}>) => void) => void
  onUpdate: (listener: () => Promise<[boolean, void | object]> | void) => void
  onLoadSource: (listener: (sourceName: string) => Promise<object> | void) => void
  onLoadSources: (listener: (sourceNames: Array<string>) => Promise<object> | void) => void
  onExecuteAction: (listener: (actionName: string, options: ExecuteActionOptions) => Promise<any> | void) => void
}

type EffectContext = {
    on: (eventName: string, listener: (event: EffectCustomEvent) => void) => void
    emit: (eventName: string, payload: any) => void
    resourceName:  () => string
    urlResourceName: () => string
    urlResourceCollectionName: () => string
    form: any
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