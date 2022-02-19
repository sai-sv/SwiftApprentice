import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// 1.
func semaphoreWithQueue() {
    let semaphore = DispatchSemaphore(value: 1)
    let globalQueue = DispatchQueue.global(qos: .utility)
    
    globalQueue.async {
        semaphore.wait() // +1
        sleep(2)
        print(Thread.current)
        print("First")
        semaphore.signal() // -1
    }
    globalQueue.async {
        semaphore.wait() // +1
        sleep(2)
        print(Thread.current)
        print("Second")
        semaphore.signal() // -1
    }
}

// 2.
func semaphoreWithConcurrentPerform() {
    let semaphore = DispatchSemaphore(value: 2)
    
    DispatchQueue.concurrentPerform(iterations: 10) { (index) in
        semaphore.wait() // +1
        sleep(1)
        print(Thread.current)
        print("Iteration: \(index)")
        semaphore.signal() // -1
    }
}

// 3.
class Worker {
    private let semaphore = DispatchSemaphore(value: 2)
    private var data = [Int]()
    
    private func task(id: Int) {
        semaphore.wait() // +1
        sleep(1)
        print(Thread.current)
        print("Append id: \(id)")
        data.append(id)
        semaphore.signal() // -1
    }
    
    public func doWork() {
        DispatchQueue.global().async { self.task(id: 123) }
        DispatchQueue.global().async { self.task(id: 456) }
        DispatchQueue.global().async { self.task(id: 789) }
        DispatchQueue.global().async { self.task(id: 0) }
    }
}
let worker = Worker()

//semaphoreWithQueue()
//semaphoreWithConcurrentPerform()
worker.doWork()
