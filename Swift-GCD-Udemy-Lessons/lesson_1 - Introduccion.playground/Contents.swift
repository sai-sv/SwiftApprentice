import Foundation

var thread = pthread_t(bitPattern: 0)
var thread_attribute = pthread_attr_t()

// 1. C style thread on Swift
pthread_attr_init(&thread_attribute)
pthread_create(&thread, &thread_attribute, { (ptr) -> UnsafeMutableRawPointer? in
    print("Hello C-style thread from Swift")
    return nil
}, nil)

// 2. Obj-C style thread
let nsthread = Thread() {
    print("Hello Obj-C thread")
}
nsthread.start()

