import Alamofire

protocol EndPointType {
    var apiKey: String { get }
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
}

enum EndpointItem {
    // MARK: User actions
    case searchBeer(query: String, page: Int)
    case searchBreweryByGeo(lat: Double, lon: Double)  // radius? def: 10 km
    case getBeerById(_: String)
    case getBeersInBrewery(_: String)
    
}

// MARK: - Extensions
// MARK: - EndPointType
//let apiKey = "fb4f791b9da06de05c6760f51581c713"
extension EndpointItem: EndPointType {
    
    // MARK: - Vars & Lets
    
    var apiKey: String {
        return "fb4f791b9da06de05c6760f51581c713"
    }
    
    var baseURL: String {
        switch APIManager.networkEnviroment {
        case .sandbox: return "https://sandbox-api.brewerydb.com"
        case .production: return "https://api.brewerydb.com"
        }
    }
    
    var version: String {
        return "/v2"
    }
    
    var path: String {
        switch self {
        case .searchBeer(let query, let page):
            return "/search?q=\(query)&p=\(page)&type=beer&key=\(self.apiKey)"
        case .searchBreweryByGeo(let lat, let lon):
            return "/search/geo/point?lat=\(lat)&lon=\(lon)&key=\(self.apiKey)"
        case .getBeerById(let beerId):
            return "/beer/\(beerId)?key=\(self.apiKey)"
        case .getBeersInBrewery(let breweryId):
            return "/brewery/\(breweryId)/beers?key=\(self.apiKey)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.version + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
}
