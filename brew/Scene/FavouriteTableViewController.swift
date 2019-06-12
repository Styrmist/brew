import UIKit
import Alamofire

protocol FavouriveProtocol {
    var beer: Dynamic<[BeerModel.BeerData?]> {get set}
}

class FavouriteTableViewController: UITableViewController, FavouriveProtocol {

    private let reuseIdentifier = "Cell"
    private let apiManager = APIManager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
    var beer:Dynamic<[BeerModel.BeerData?]> = Dynamic([nil])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favourive beer"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beer.value.removeAll()
        let favouriteAmount = Constants.savedBeer.count
        var startPoint = 0
        var endPoint = 0
        if favouriteAmount == 0 {
            return
        }
        repeat{
            endPoint += 10
            
            if favouriteAmount < endPoint + startPoint {
                endPoint = favouriteAmount
            }
            let tempSaved = Constants.savedBeer[startPoint..<endPoint]
            self.apiManager.call(type: RequestItemsType.getBeers(Array(tempSaved))) { (res: Swift.Result<[BeerModel.BeerData], AlertMessage>, pages: Int)  in
                switch res {
                case .success(let beer):
                    for data in beer {
                        self.beer.value.append(data)
                    }
                    self.tableView.reloadData()
                    break
                case .failure(let message):
                    print("alert \(message.body)")
                    break
                }
            }
            startPoint += 10
        }while (endPoint < favouriteAmount)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beer.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BeerTableViewCell
        guard let currentBeer = self.beer.value[indexPath.row] else { return cell }
        cell.beerLabel!.text = currentBeer.name
        cell.beerType.text = currentBeer.style?.name
        self.apiManager.fetchImage(url: currentBeer.labels?.icon ?? Constants.defaultImage, completionHandler: { image in
            cell.beerImage.image = image
        })
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favouriteSegue"{
            if let cellIndex = self.tableView.indexPathsForSelectedRows {
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
