//
//  EventDetailsViewController.swift
//  EventsManager
//
//  Created by Thiago Costa on 6/8/22.
//

import UIKit
import MapKit

class EventDetailsViewController: UIViewController {

    private let cornerRadius: CGFloat = 12    
    @IBOutlet weak var eventNameDescriptionContainerView: UIView!
    @IBOutlet weak var eventDateContainerView: UIView!
    @IBOutlet weak var eventRsvpContainerView: UIView!
    @IBOutlet weak var eventAddressContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var rsvpSwitcher: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    
    var model: Event?
    private let modelController = EventModelController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMapView()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {        
        guard let name = nameTextField.text,
              let description = descriptionTextView.text else {
            return
        }
        let date = datePicker.date
        let rsvp = rsvpSwitcher.isOn
        
        if let model = model {
            modelController.update(event: model, name: name, description: description, date: date, rsvp: rsvp)
        } else {
            modelController.save(name: name, description: description, date: date, rsvp: rsvp, address: "")
        }
        dismiss(animated: true)
    }
    
    
}

private extension EventDetailsViewController {
    func configureUI() {
        eventNameDescriptionContainerView.layer.cornerRadius = cornerRadius
        eventDateContainerView.layer.cornerRadius = cornerRadius
        eventRsvpContainerView.layer.cornerRadius = cornerRadius
        eventAddressContainerView.layer.cornerRadius = cornerRadius
        descriptionTextView.layer.cornerRadius = cornerRadius
        mapView.layer.cornerRadius = cornerRadius
        
        guard let model = model,
              let eventDate = model.date else {
            return
        }

        nameTextField.text = model.name
        descriptionTextView.text = model.desc
        datePicker.date = eventDate
        rsvpSwitcher.isOn = model.rsvp
    }
    
    func configureMapView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(touchAction(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
   
    @objc
    func touchAction(_ sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        guard let addressSearchMapViewController = storyBoard.instantiateViewController(withIdentifier: "AddressSearchMapViewController") as? AddressSearchMapViewController else {
            return
        }
        
        self.navigationController?.pushViewController(addressSearchMapViewController, animated: true)
        
    }
}

