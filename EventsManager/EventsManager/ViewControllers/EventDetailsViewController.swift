//
//  EventDetailsViewController.swift
//  EventsManager
//
//  Created by Thiago Costa on 6/8/22.
//

import UIKit

class EventDetailsViewController: UIViewController {

    private let cornerRadius: CGFloat = 12
    @IBOutlet weak var eventNameDescriptionContainerView: UIView!
    @IBOutlet weak var eventDateContainerView: UIView!
    @IBOutlet weak var eventRsvpContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var rsvpSwitcher: UISwitch!
    
    var model: Event?
    private let modelController = EventModelController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
            modelController.save(name: name, description: description, date: date, rsvp: rsvp)
        }
        dismiss(animated: true)
    }
}

private extension EventDetailsViewController {
    func configureUI() {
        eventNameDescriptionContainerView.layer.cornerRadius = cornerRadius
        eventDateContainerView.layer.cornerRadius = cornerRadius
        eventRsvpContainerView.layer.cornerRadius = cornerRadius
        descriptionTextView.layer.cornerRadius = cornerRadius
        
        guard let model = model,
              let eventDate = model.date else {
            return
        }

        nameTextField.text = model.name
        descriptionTextView.text = model.desc
        datePicker.date = eventDate
        rsvpSwitcher.isOn = model.rsvp
    }
}

