import Foundation

// 1.
class RecursiveMutexTest {
    
    private var mutex = pthread_mutex_t()
    private var mutexAttribute = pthread_mutexattr_t()
    
    init() {
        pthread_mutexattr_init(&mutexAttribute)
        pthread_mutexattr_settype(&mutexAttribute, PTHREAD_MUTEX_RECURSIVE) // Recursive Mutex!
        pthread_mutex_init(&mutex, &mutexAttribute)
    }
    
    func foo() {
        pthread_mutex_lock(&mutex)
        print("foo")
        bar()
        pthread_mutex_unlock(&mutex)
        print("exit foo")
    }
    
    private func bar() {
        pthread_mutex_lock(&mutex)
        print("bar")
        pthread_mutex_unlock(&mutex)
    }
}

// 2.
class RecursiveMutexThread: Thread {
    let mutex = NSRecursiveLock() // Recursive Mutex!
    
    override func main() {
        mutex.lock()
        print("main")
        foo()
        mutex.unlock()
        print("exit main")
    }
    func foo() {
        mutex.lock()
        print("foo")
        mutex.unlock()
    }
}

// 1. Run
let obj1 = RecursiveMutexTest()
obj1.foo()

// 2. Run
let th = RecursiveMutexThread()
th.start()
