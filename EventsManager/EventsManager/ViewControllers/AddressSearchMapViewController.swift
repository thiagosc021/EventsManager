//
//  ViewController.swift
//  EventsManager
//
//  Created by Costa on 7/12/22.
//

import UIKit
import MapKit

class AddressSearchMapViewController: UIViewController {
    private var resultSearchController:UISearchController? = nil

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddressSearchViewController()
        configureAddressSearchBar()
        self.hideKeyboardWhenTappedAround()
    }
}

private extension AddressSearchMapViewController {
    func configureAddressSearchViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        guard let locationSearchTable = storyBoard.instantiateViewController(withIdentifier: "AddressSearchTableViewController") as? AddressSearchTableViewController else {
            return
        }
        locationSearchTable.mapView = mapView
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
    }
    
    func configureAddressSearchBar() {
        guard let resultSearchController = resultSearchController else {
            return
        }
        let searchBar = resultSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for event address"
        navigationItem.titleView = resultSearchController.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
}

