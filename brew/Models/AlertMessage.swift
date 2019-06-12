import Foundation

class AlertMessage: Error {
    
    var title = ""
    var body = ""
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
