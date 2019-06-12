import UIKit
import SwiftyJSON
import Alamofire

protocol SearchProtocol {
    var beer: Dynamic<[BeerModel.BeerData?]> {get set}
}

class SearchTableViewController: UITableViewController, SearchProtocol {
    
    private let reuseIdentifier = "Cell"
    let searchController = UISearchController(searchResultsController: nil)
    let apiManager = APIManager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
    let minInterval = 0.1
    var previousRun = Date()

    var beer:Dynamic<[BeerModel.BeerData?]> = Dynamic([nil])
    var currentPage = 1
    var amountOfPages = 0
    
    var searchResults = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        beer.value.removeAll()
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView()
        setupTableViewBackgroundView()
        setupSearchBar()
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
        if segue.identifier == "searchSegue"{
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

    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search any Topic"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func setupTableViewBackgroundView() {
        let backgroundViewLabel = UILabel(frame: .zero)
        backgroundViewLabel.textColor = .darkGray
        backgroundViewLabel.numberOfLines = 0
        backgroundViewLabel.textAlignment = NSTextAlignment.center
        backgroundViewLabel.font.withSize(20)
        tableView.backgroundView = backgroundViewLabel
    }
    
    func search(searchText: String, completionHandler: @escaping ([JSON]?, NetworkError) -> ()) {}
    
    func fetchImage(url: String, completionHandler: @escaping (UIImage?, NetworkError) -> ()) {}
}
