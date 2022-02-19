import Foundation

// 1. ReadWriteLock
class ReadWriteLock {
    private var rwLock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    private var unsafeData: Int = 0
    
    init() {
        pthread_rwlockattr_init(&attribute)
        pthread_rwlock_init(&rwLock, &attribute)
    }
    
    public var dataProperty: Int  {
        get {
            pthread_rwlock_rdlock(&rwLock)
            let tmp = unsafeData
            pthread_rwlock_unlock(&rwLock)
            return tmp
        }
        set {
            pthread_rwlock_wrlock(&rwLock)
            unsafeData = newValue
            pthread_rwlock_unlock(&rwLock)
        }
    }
}

// 2. Deprecated in iOS 10 !
class SpinLock {
    private var spinLock = OS_SPINLOCK_INIT
    
    func foo() {
        OSSpinLockLock(&spinLock)
        // do something...
        OSSpinLockUnlock(&spinLock)
    }
}

// 3. UnfairLock
class UnfairLock {
    private var unfairLock = os_unfair_lock()
    
    func foo() {
        os_unfair_lock_lock(&unfairLock)
        // do something...
        os_unfair_lock_unlock(&unfairLock)
    }
}

// 4. Synchronized Objc
class SynchronizedObjc {
    private let lock = NSObject()
    
    func foo() {
        objc_sync_enter(lock)
        // do something...
        objc_sync_exit(lock)
    }
}
