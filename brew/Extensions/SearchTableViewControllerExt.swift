import UIKit
import SwiftyJSON
import Alamofire

extension SearchTableViewController: UITableViewDataSourcePrefetching, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        currentPage = 1
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            self.apiManager.call(type: RequestItemsType.searchBeer(query: textToSearch, page: currentPage)) { (res: Swift.Result<[BeerModel.BeerData], AlertMessage>, pages: Int)  in
                
                switch res {
                case .success(let beer):
                    self.beer.value.removeAll()
                    for data in beer {
                        self.beer.value.append(data)
                    }
                    self.tableView.reloadData()
                    self.amountOfPages = pages
                    self.currentPage += 1
                    break
                case .failure(let message):
                    print("alert \(message.body)")
                    break
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.last?[1] == self.beer.value.count - 1 {
            if amountOfPages != 0 && currentPage <= amountOfPages {
                self.apiManager.call(type: RequestItemsType.searchBeer(query: searchController.searchBar.text ?? "", page: currentPage)) { (res: Swift.Result<[BeerModel.BeerData], AlertMessage>, pages: Int)   in
                    switch res {
                    case .success(let beer):
                        for data in beer {
                            self.beer.value.append(data)
                        }
                        self.tableView.reloadData()
                        self.amountOfPages = pages
                        self.currentPage += 1
                        break
                    case .failure(let message):
                        print("alert \(message.body)")
                        break
                    }
                }
            }
        }
    }
}
