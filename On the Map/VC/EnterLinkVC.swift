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
    var mapString: String?
    
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
        
        let studentLocation = StudentLocation(objectId: nil,
                                              uniqueKey: UserInfo.uniqueKey, // should be user uniq key
                                              firstName: UserInfo.firstName, // should be user first name
                                              lastName: UserInfo.lastName, // should be user last name
                                              mapString: mapString ?? "",
                                              mediaURL: textField.text ?? "",
                                              latitude: location?.coordinate.latitude,
                                              longitude: location?.coordinate.longitude)

        Client.postingStudentLocation(studentLocation: studentLocation) { (success, error) in
            if success {
                self.performSegue(withIdentifier: "unwindToMapVC", sender: self)
            } else {
                self.showFailureAlert(message: "Impossible to post this location")
            }
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
