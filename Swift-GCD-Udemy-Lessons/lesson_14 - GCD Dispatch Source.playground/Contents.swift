import Foundation

let source = DispatchSource.makeTimerSource(queue: .global())
source.setEventHandler {
    print("Hello World!")
}
source.schedule(deadline: .now(), repeating: 2)
source.activate()
