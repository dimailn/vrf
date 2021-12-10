export default class VrfEvent<T> {
  eventName: string
  payload: T
  private __stopped: boolean = false
  
  constructor(eventName: string, payload: T){
    this.eventName = eventName
    this.payload = payload
  }

  stopPropagation = () => {
    this.__stopped = true
  }

  isStopped = () => {
    return this.__stopped
  }
}

