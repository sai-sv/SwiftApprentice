import Foundation

// 1. pthread
var attribute = pthread_attr_t()
pthread_attr_init(&attribute)
pthread_attr_set_qos_class_np(&attribute, QOS_CLASS_USER_INITIATED, 0)

var pthread = pthread_t(bitPattern: 0)
pthread_create(&pthread, &attribute, { (ptr) -> UnsafeMutableRawPointer? in
    print("Hello pthread")
    pthread_set_qos_class_self_np(QOS_CLASS_DEFAULT, 0)
    return nil
}, nil)

// 2. Thread
var thread = Thread {
    print("Hello Thread")
    print(qos_class_self())
}
thread.qualityOfService = .background
thread.start()

print(qos_class_main())
