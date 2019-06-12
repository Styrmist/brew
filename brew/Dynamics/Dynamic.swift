class Dynamic<T> {
    
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    var value: T {
        didSet {
            self.fire()
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    internal func fire() {
        self.listener?(value)
    }
}
