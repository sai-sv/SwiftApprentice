import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class ThreadSafeArray<T> {
    private let queue = DispatchQueue(label: "TreadSafeArrayQueue", attributes: .concurrent)
    private var array = [T]()
    
    func append(_ value: T) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.array.append(value)
        }
    }
    
    var valueArray: [T]  {
        var result = [T]()
        queue.sync { [weak self] in
            guard let self = self else { return }
            result = self.array
        }
        return result
    }
}

let threadSafeArray = ThreadSafeArray<Int>()
DispatchQueue.concurrentPerform(iterations: 10) { (i) in
    threadSafeArray.append(i)
}
print(threadSafeArray.valueArray)
print(threadSafeArray.valueArray.count)
