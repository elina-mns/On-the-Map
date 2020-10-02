//
//  EnterLinkVC.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-10-01.
//

import UIKit
import MapKit

class EnterLinkVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextView!
    
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let annotation = MKPointAnnotation()
        annotation.coordinate = location!.coordinate
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegion(center: location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        guard !textField.text.isEmpty else {
            showFailureAlert(message: "Please fill the link")
            return
        }
        var dictToInsert: [String: Any] = [:]
        dictToInsert["createdAt"] = Date()
        dictToInsert["firstName"] = "Jopa"
        dictToInsert["lastName"] = "Jopio"
        dictToInsert["latitude"] = location?.coordinate.latitude
        dictToInsert["longitude"] = location?.coordinate.longitude
        dictToInsert["mapString"] = "something"
        dictToInsert["mediaURL"] = textField.text
        (UIApplication.shared.delegate as? AppDelegate)?.hardCodedLocations.append(dictToInsert)
        performSegue(withIdentifier: "unwindToMapVC", sender: self)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
