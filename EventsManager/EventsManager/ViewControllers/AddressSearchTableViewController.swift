//
//  AddressSearchTableViewController.swift
//  EventsManager
//
//  Created by Costa on 7/11/22.
//

import UIKit
import MapKit

class AddressSearchTableViewController: UITableViewController {
    private var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
}

extension AddressSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return matchingItems.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
    }
}

extension AddressSearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
        let searchBarText = searchController.searchBar.text else {
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let self = self,
                  let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
            
        }
    }
    
}
