import Foundation

class CustomQuues {
    private let customSerialQueue = DispatchQueue(label: "CustomSerialQueue")
    private let customConcurrentQueue = DispatchQueue(label: "CustomConcurrentQueue", attributes: .concurrent)
}

class SystemQueues {
    private let globalQueue = DispatchQueue.global()
    private let mainQueue = DispatchQueue.main
}
