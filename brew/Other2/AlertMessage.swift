class AlertMessage: Error {
    
    // MARK: - Vars & Lets
    var title = ""
    var body = ""
    
    // MARK: - Intialization
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
