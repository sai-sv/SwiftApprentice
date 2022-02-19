import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// 1. Operation
let operation = Operation()
operation.completionBlock = {
    print("Operation Thread: ", Thread.current)
}

// 2. Operation Block
let operationBlock = BlockOperation {
    print("Operation Block", Thread.current)
}

// 3. Custom Operation
class CustomOperation: Operation {
    override func main() {
        print("Custom Operation", Thread.current)
    }
}
let customOperation = CustomOperation()

// Operation Queue
let operationQueue = OperationQueue()
operationQueue.addOperation {
    print("Operation Closure", Thread.current)
}
operationQueue.addOperation(operation)
operationQueue.addOperation(operationBlock)
operationQueue.addOperation(customOperation)

