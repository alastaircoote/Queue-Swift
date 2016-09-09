import Dispatch


public struct Queue: Equatable {
    var queue: DispatchQueue
    
    public init() {
        self.queue = DispatchQueue(label: "", attributes: [])
    }
    
    public init(_ queue: DispatchQueue) {
        self.queue = queue
    }
    
    public func sync<T>(_ block: () -> T) -> T {
        var result: T? = nil
        sync {
            result = block()
        }
        return result!
    }
   
    public func sync(_ block: () -> ()) {
        queue.sync(execute: block)
    }

    public func sync(_ barrier: Bool, block: () -> ()) {
        if barrier {
            queue.sync(flags: .barrier, execute: block)
        } else {
            queue.sync(execute: block)
        }
    }

    public func async(_ block: @escaping () -> ()) {
        queue.async(execute: block)
    }

    public func async(_ barrier: Bool, _ block: @escaping () -> ()) {
        if barrier {
            queue.async(flags: .barrier, execute: block)
        } else {
            queue.async(execute: block)
        }
    }
    
    public func afterDelayInNanos(_ nanos: Int64, _ block: @escaping () -> ()) {
        assert(nanos >= 0, "We can't dispatch into the past.")
        queue.asyncAfter(deadline: DispatchTime.now() + Double(nanos) / Double(NSEC_PER_SEC), execute: block)
    }
    
    public func afterDelayInSeconds(_ seconds: Double, _ block: @escaping () -> ()) {
        assert(seconds >= 0, "We can't dispatch into the past.")
        queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }
    
    public func withTarget(_ target: Queue) -> Queue {
        self.queue.setTarget(queue: target.queue)
        return self
    }
    
    public func suspend() -> Queue {
        queue.suspend()
        return self
    }
    
    public func resume() -> Queue {
        queue.resume()
        return self
    }

    public static let Main = Queue(DispatchQueue.main)
    public static let Background = Queue(DispatchQueue.global())
}


public func ==(lhs: Queue, rhs: Queue) -> Bool {
    return lhs.queue === rhs.queue
}
