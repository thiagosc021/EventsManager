//
//  ViewController.swift
//  EventsManager
//
//  Created by Costa on 7/12/22.
//

import UIKit
import MapKit

protocol AddressSearchMapViewControllerDelegate: AnyObject {
    func selectAddress(mapItem: MKMapItem)
}

class AddressSearchMapViewController: UIViewController {
    private var resultSearchController:UISearchController? = nil
    private var mapItem: MKMapItem?
    @IBOutlet weak var mapView: MKMapView!
    weak var delegate: AddressSearchMapViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddressSearchViewController()
        configureAddressSearchBar()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let mapItem = mapItem else {
            return
        }

        delegate?.selectAddress(mapItem: mapItem)
    }
}

private extension AddressSearchMapViewController {
    func configureAddressSearchViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        guard let locationSearchTable = storyBoard.instantiateViewController(withIdentifier: "AddressSearchTableViewController") as? AddressSearchTableViewController else {
            return
        }
        locationSearchTable.mapView = mapView
        locationSearchTable.delegate = self
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

extension AddressSearchMapViewController: AddressSearchMapViewControllerDelegate {
    func selectAddress(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
}
