//
//  AddressSearchTableViewController.swift
//  EventsManager
//
//  Created by Costa on 7/11/22.
//

import UIKit
import MapKit
import Contacts

class AddressSearchTableViewController: UITableViewController {
    private var matchingItems:[MKMapItem] = []
    private let formatter =  { () -> CNPostalAddressFormatter in
        var formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter
    }()
    var mapView: MKMapView? = nil
    weak var delegate: AddressSearchMapViewControllerDelegate?
}

extension AddressSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return matchingItems.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell"),
              let postalAddress = matchingItems[indexPath.row].placemark.postalAddress else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = formatter.string(from: postalAddress).replacingOccurrences(of: "\n", with: ", ")
        cell.detailTextLabel?.text = ""
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = matchingItems[indexPath.row]
        let currentRegion = MKCoordinateRegion(center: selectedAddress.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        mapView?.addAnnotation(selectedAddress.placemark)
        mapView?.setRegion(currentRegion, animated: true)
        delegate?.selectAddress(mapItem: selectedAddress)
        self.dismiss(animated: true)
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
