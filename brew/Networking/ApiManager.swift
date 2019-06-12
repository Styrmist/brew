import Alamofire
import SwiftyJSON
class APIManager {
    
    private let sessionManager: SessionManager
    private let retrier: APIManagerRetrier
    static let networkEnviroment: NetworkEnvironment = .sandbox
    
    
    func fetchImage(url: String, completionHandler: @escaping (UIImage?) -> ()) {
        Alamofire.request(url).responseData { responseData in
            guard let imageData = responseData.data else {
                completionHandler(nil)
                return
            }
            guard let image = UIImage(data: imageData) else {
                completionHandler(nil)
                return
            }
            completionHandler(image)
        }
    }
    
    func call<T>(type: EndPointType, params: Parameters? = nil, handler: @escaping (Swift.Result<T, AlertMessage>, Int) -> Void) where T: Codable {
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseData() { (data) in
                                        do {
                                            guard let jsonData = data.data else {
                                                throw AlertMessage(title: "Error", body: "No data")
                                            }
                                            var temp = try JSON(data: jsonData)
                                            let pages = temp["numberOfPages"].int ?? 0
                                            let tempData = try JSONEncoder().encode(temp["data"])
                                            let result = try JSONDecoder().decode(T.self, from: tempData)

                                            handler(.success(result), pages)
                                            self.resetNumberOfRetries()
                                        } catch {
                                            if let error = error as? AlertMessage {
                                                return handler(.failure(error), 0)
                                            }
                                            
                                            handler(.failure(self.parseApiError(data: data.data)), 0)
                                        }
        }
    }
    
    private func resetNumberOfRetries() {
        self.retrier.numberOfRetries = 0
    }
    
    private func parseApiError(data: Data?) -> AlertMessage {
        let decoder = JSONDecoder()
        if let jsonData = data, let error = try? decoder.decode(NetworkError.self, from: jsonData) {
            return AlertMessage(title: Constants.errorAlertTitle, body: error.key ?? error.message)
        }
        return AlertMessage(title: Constants.errorAlertTitle, body: Constants.genericErrorMessage)
    }
    
    init(sessionManager: SessionManager, retrier: APIManagerRetrier) {
        self.sessionManager = sessionManager
        self.retrier = retrier
        self.sessionManager.retrier = self.retrier
    }
    
}
