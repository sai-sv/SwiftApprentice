import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Operation - Wait Until Finished
class CancelOperation {
    private let operationQueue = OperationQueue()
    
    func foo() {
        operationQueue.addOperation {
            sleep(1)
            print("task 1:", Thread.current)
        }
        operationQueue.addOperation {
            sleep(2)
            print("task 2:", Thread.current)
        }
        
        // wait task 1 and task 2 completion
        operationQueue.waitUntilAllOperationsAreFinished()
        
        operationQueue.addOperation {
            print("task 3:", Thread.current)
        }
        operationQueue.addOperation {
            print("task 4:", Thread.current)
        }
    }
}
let cancelOperation = CancelOperation()
cancelOperation.foo()

// Block Operation - Wait Until Finished, Completion
class CancelBlockOperation {
    private let operationQueue = OperationQueue()
    
    func foo() {
        let op1 = BlockOperation {
            sleep(1)
            print("task 1: ", Thread.current)
        }
        let op2 = BlockOperation {
            sleep(2)
            print("task 2: ", Thread.current)
        }
        
        // wait task 1 and task 2 completion
        operationQueue.addOperations([op1, op2], waitUntilFinished: true)
        
        let op3 = BlockOperation {
            print("task 3: ", Thread.current)
        }
        let op4 = BlockOperation {
            print("task 4: ", Thread.current)
        }
        op4.completionBlock = {
            print("task 4, completed")
        }
        operationQueue.addOperation(op3)
        operationQueue.addOperation(op4)
    }
}
let cancelBlockOperation = CancelBlockOperation()
cancelBlockOperation.foo()
