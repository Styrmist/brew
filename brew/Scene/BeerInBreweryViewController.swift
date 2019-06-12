import UIKit
import Alamofire

protocol BeerInBreweryProtocol {
    var beer: Dynamic<[BeerModel.BeerData?]> {get set}
}

class BeerInBreweryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BeerInBreweryProtocol {
    
    private let reuseIdentifier = "Cell"
    private let apiManager = APIManager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
    var beer:Dynamic<[BeerModel.BeerData?]> = Dynamic([nil])
    var currentPage = 1
    var amountOfPages = 0
    
    var breweryId: String?
    var breweryName: String?
    var breweryImage: String?
    var breweryDescription: String?
    
    @IBOutlet weak var breweryImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var beerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beer.value.removeAll()
        beerTableView.delegate = self
        beerTableView.dataSource = self
        self.navigationItem.title = breweryName
        self.descriptionLabel.text = breweryDescription ?? "This brewery has no description"
        self.apiManager.fetchImage(url: breweryImage ?? Constants.defaultImage, completionHandler: { image in
            self.breweryImageView.image = image
        })

        self.apiManager.call(type: RequestItemsType.getBeersInBrewery(breweryId!)) { (res: Swift.Result<[BeerModel.BeerData], AlertMessage>, pages: Int)  in
            self.amountOfPages = pages
            switch res {
            case .success(let beer):
                self.beer.value.removeAll()
                for data in beer {
                    self.beer.value.append(data)
                }
                self.beerTableView.reloadData()
                self.currentPage = 1
                break
            case .failure(let message):
                print("alert \(message.body)")
                break
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beer.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BeerTableViewCell
        guard let currentBeer = self.beer.value[indexPath.row] else { return cell }
        cell.beerLabel.text = currentBeer.name
        cell.beerType.text = currentBeer.style?.name
        self.apiManager.fetchImage(url: currentBeer.labels?.icon ?? Constants.defaultImage, completionHandler: { image in
            cell.beerImage.image = image
        })
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beerInBrewerySegue"{
            if let cellIndex = self.beerTableView.indexPathsForSelectedRows {
                let detailVC = segue.destination as! DetailViewController
                guard let currentBeer = self.beer.value[cellIndex[0].row] else { return }
                detailVC.labelStorage = currentBeer.name
                detailVC.shortTypeStorage = currentBeer.style?.name
                detailVC.abvStorage = currentBeer.abv
                detailVC.ibuStorage = currentBeer.ibu
                detailVC.descriptionStorage = currentBeer.description
                detailVC.imageStorage = currentBeer.labels?.icon
                detailVC.idStorage = currentBeer.id
                
            }
        }
    }
}
