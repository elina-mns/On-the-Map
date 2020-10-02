//
//  EnterLocationVC.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-10-01.
//

import UIKit
import MapKit
import CoreLocation

var mapView: MKMapView!

class EnterLocationVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapFindOnTheMap(_ sender: UIButton) {
        let address = text.text ?? ""
        
        loadView(isLoading: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            self.loadView(isLoading: false)
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                self.showFailureAlert(message: error?.localizedDescription ?? "")
                return
            }
            self.showEnterLinkVC(with: location)
        }
    }
    
    func showEnterLinkVC(with location: CLLocation) {
        let newViewController = storyboard?.instantiateViewController(identifier: "EnterLink") as! EnterLinkVC
        newViewController.location = location
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    private func loadView(isLoading: Bool) {
        activityIndicator.isHidden = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        findOnTheMapButton.isEnabled = !isLoading
    }
}
