import Foundation

// 1.
var mutex = pthread_mutex_t()
var condition = pthread_cond_t()
var isAvaliable = false

pthread_mutex_init(&mutex, nil)
pthread_cond_init(&condition, nil)

class Reader: Thread {
    
    override func main() {
        foo()
    }
    
    private func foo() {
        
        pthread_mutex_lock(&mutex)
        print("Reader enter")
        
        while (!isAvaliable) {
            pthread_cond_wait(&condition, &mutex) // condition wait
        }
        print("ready for read")
        
        pthread_mutex_unlock(&mutex)
        print("Reader exit")
    }
}

class Writer: Thread {
    
    override func main() {
        foo()
    }
    
    private func foo() {
        pthread_mutex_lock(&mutex)
        print("Writer enter")
        
        isAvaliable = true
        pthread_cond_signal(&condition) // condition signal
        
        pthread_mutex_unlock(&mutex)
        print("Writer exit")
    }
}


let reader = Reader()
let writer = Writer()
reader.start()
writer.start()


// 2.
let nsCondition = NSCondition()
var isDataAvailable = false

class ReaderThread: Thread {
    override func main() {
        foo()
    }
    
    private func foo() {
        nsCondition.lock()
        print("Reader Thread enter")
        
        while (!isDataAvailable) {
            nsCondition.wait()
        }
        isAvaliable = false
        
        nsCondition.unlock()
        print("Reader Thread exit")
    }
}

class WriterThread: Thread {
    override func main() {
        foo()
    }
    
    private func foo() {
        nsCondition.lock()
        print("Writer Thread enter")
        
        isDataAvailable = true
        nsCondition.signal()
        
        nsCondition.unlock()
        print("Writer Thread exit")
    }
}

let readerThread = ReaderThread()
let writerThread = WriterThread()
readerThread.start()
writerThread.start()

