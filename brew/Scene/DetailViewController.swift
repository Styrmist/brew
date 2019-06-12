import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    private let apiManager = APIManager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerShortType: UILabel!
    @IBOutlet weak var beerIBU: UILabel!
    @IBOutlet weak var beerABV: UILabel!
    @IBOutlet weak var beerDescription: UILabel!
    
    var labelStorage: String?
    var ibuStorage: String?
    var abvStorage: String?
    var shortTypeStorage: String?
    var descriptionStorage: String?
    var imageStorage: String?
    var idStorage: String = ""
    var saved: Bool = false
    
    @IBAction func savePressed(_ sender: UIButton) {
        if saved {
            Constants.savedBeer = Constants.savedBeer.filter {$0 != idStorage}
            saved = false
            saveButton.setTitle("Save", for: .normal)
        }else{
            Constants.savedBeer.append(idStorage)
            saved = true
            saveButton.setTitle("Remove", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for element in Constants.savedBeer {
            if idStorage == element {
                saved = true
                saveButton.setTitle("Remove", for: .normal)
            }
        }
        beerShortType.text = shortTypeStorage
        beerIBU.text = ibuStorage ?? "n/a"
        beerABV.text = abvStorage ?? "n/a"
        beerDescription.text = descriptionStorage ?? "This beer has no description"
        beerDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.apiManager.fetchImage(url: imageStorage ?? Constants.defaultImage, completionHandler: { image in
            self.beerImage.image = image
        })
        self.navigationItem.title = labelStorage
    }
}
