import Foundation
import SwiftyJSON
import Alamofire

class RequestFetcher {
    
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
}
