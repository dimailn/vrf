import RfFormComponent from '../components/descriptors/form'

type RfForm = InstanceType<typeof RfFormComponent>

type OnLoadResult = [boolean, object]

interface ExecuteActionOptions {
    params?: object
    data?: any
    method?: string
    url?: string
}

interface EffectContext {
    onLoad: (listener: () => Promise<OnLoadResult> | void) => void
    onSave: (listener: () =>  Promise<object> | void) => void
    onLoadSource: (listener: (sourceName: string) => Promise<object> | void) => void
    onLoadSources: (listener: (sourceNames: Array<string>) => Promise<object> | void) => void
    onExecuteAction: (listener: (actionName: string, options: ExecuteActionOptions) => Promise<any> | void) => void
    form: RfForm
}

export type EffectExecutor = (context: EffectContext) => void
export type Effect = {
    effect: EffectExecutor
    name: string
    api?: boolean
}


export type EffectListenerNames = keyof Omit<EffectContext, "form">
export type InstantiatedEffect = {
    listeners: {
        [EventName in EffectListenerNames]: Parameters<EffectContext[EventName]>[0]
    }
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