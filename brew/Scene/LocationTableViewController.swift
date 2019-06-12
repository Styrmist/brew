import UIKit
import Alamofire
import CoreLocation

protocol LocationProtocol {
    var brew: Dynamic<[BrewModel.BreweryData?]> {get set}
}

class LocationTableViewController: UITableViewController, CLLocationManagerDelegate, LocationProtocol {

    private let reuseIdentifier = "cell"
    private let apiManager = APIManager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
    
    let locationManager = CLLocationManager()
    var brew:Dynamic<[BrewModel.BreweryData?]> = Dynamic([nil])
    var currentPage = 1
    var amountOfPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Nearest breweries"
        brew.value.removeAll()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.apiManager.call(type: RequestItemsType.searchBreweryByGeo(lat: location.latitude, lon: location.longitude)) { (res: Swift.Result<[BrewModel.BreweryData], AlertMessage>, pages: Int)  in
            self.amountOfPages = pages
            switch res {
            case .success(let brew):
                self.brew.value.removeAll()
                for data in brew {
                    self.brew.value.append(data)
                }
                
                self.tableView.reloadData()
                self.currentPage = 1
                break
            case .failure(let message):
                print("alert \(message.body)")
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "brewSegue"{
            if let cellIndex = self.tableView.indexPathsForSelectedRows {
                let beerInBrewVC = segue.destination as! BeerInBreweryViewController
                guard let currentBrew = self.brew.value[cellIndex[0].row]?.brewery! else { return }
                beerInBrewVC.breweryId = currentBrew.id
                beerInBrewVC.breweryName = currentBrew.name
                beerInBrewVC.breweryImage = currentBrew.images?.icon
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brew.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BrewTableViewCell
        guard let currentBrew = self.brew.value[indexPath.row]?.brewery else { return cell }
        cell.brewLabel.text = currentBrew.name
        return cell
    }
}
