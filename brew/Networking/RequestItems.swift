import Foundation
import Alamofire

enum NetworkEnvironment {
    case sandbox
    case production
}

enum RequestItemsType {
    
    case searchBeer(query: String, page: Int)
    case searchBreweryByGeo(lat: Double, lon: Double)  // radius? def: 10 km
    case getBeerById(_: String)
    case getBeers(_: [String])
    case getBeersInBrewery(_: String)
}

extension RequestItemsType: EndPointType {
    
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
            return "/search/geo/point?lat=\(lat)&lng=\(lon)&radius=100&key=\(self.apiKey)"
        case .getBeerById(let beerId):
            return "/beer/\(beerId)?key=\(self.apiKey)"
        case .getBeers(let beers):
            return "/beers?ids=\(beers.joined(separator: ","))&key=\(self.apiKey)"
        case .getBeersInBrewery(let breweryId):
            return "/brewery/\(breweryId)/beers?key=\(self.apiKey)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
            return ["Content-Type": "application/json"]
    }
    
    var url: URL {
            return URL(string: self.baseURL + self.version + self.path)!
    }
    
    var encoding: ParameterEncoding {
            return JSONEncoding.default
    }
}
