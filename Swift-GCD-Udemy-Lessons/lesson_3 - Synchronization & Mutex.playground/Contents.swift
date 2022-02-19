import Foundation

// 1.
class FooClass {
    
    private var mutex = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    func sameMethod(completion: () -> Void) {
        pthread_mutex_lock(&mutex)
        completion()
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}

// 2.
class BarClass: NSObject {
    var mutex = NSLock()
    
    func sameMethod(completion: () -> Void) {
        mutex.lock()
        completion()
        defer {
            mutex.unlock()
        }
    }
}

var arr = [String]()

let th1 = FooClass()
th1.sameMethod {
    print("test 1")
    arr.append("test 1")
}

let th2 = BarClass()
th1.sameMethod {
    print("test 2")
    arr.append("test 2")
}
