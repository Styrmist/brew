import Alamofire

class APIManager {
    
    // MARK: - Vars & Lets
    private let sessionManager: SessionManager
    static let networkEnviroment: NetworkEnvironment = .sandbox
    
    // MARK: - Vars & Lets
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: SessionManager())
        return apiManager
    }()
    
    // MARK: - Accessors
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    private init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func call<T>(type: EndPointType, params: Parameters? = nil, handler: @escaping (Swift.Result<T, AlertMessage>) -> Void) where T: Codable {
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseJSON { (data) in
                                        do {
                                            guard let jsonData = data.data else {
                                                throw AlertMessage(title: "Error", body: "No data")
                                            }
                                            let result = try JSONDecoder().decode(T.self, from: jsonData)
                                            handler(.success(result))
                                        } catch {
                                            if let error = error as? AlertMessage {
                                                return handler(.failure(error))
                                            }
                                            
                                            handler(.failure(self.parseApiError(data: data.data)))
                                        }
        }
    }
    
}
