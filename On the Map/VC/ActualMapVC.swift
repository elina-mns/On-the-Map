//
//  ActualMapVC.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-29.
//

import UIKit
import MapKit
import FBSDKLoginKit

class ActualMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "1")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterOnUserLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAnnotationsToMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let mapPin = UIBarButtonItem(image: UIImage(systemName: "mappin"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(showEnterLocationVC))
        
        let reverseButton = UIBarButtonItem(image: UIImage(systemName: "goforward"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(reload))
        navigationItem.rightBarButtonItems = [mapPin, reverseButton]
        
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutButton
        
        
        view.addSubview(centerMapButton)
        centerMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        centerMapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        centerMapButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerMapButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerMapButton.layer.cornerRadius = 50 / 2
        centerMapButton.alpha = 1
        reload()
       
        
        configureLocationManager()
        handleCenterOnUserLocation()
    }
    
    @objc func handleCenterOnUserLocation() {
        centerMapOnUserLocation()
    }
    
    @objc func logout() {
        if UserInfo.isFromFacebook {
            LoginManager().logOut()
            self.dismiss(animated: true, completion: nil)
        } else {
            Client.logout {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func reload() {
        (UIApplication.shared.delegate as? AppDelegate)?.reload(completion: { (error) in
            guard let error = error else {
                self.addAnnotationsToMap()
                return
            }
            self.showFailureAlert(message: error.localizedDescription)
        })
    }
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    @objc func showEnterLocationVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "EnterLocation") as! EnterLocationVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if seg.source is EnterLinkVC {
            addAnnotationsToMap()
        }
    }
    
    
    func addAnnotationsToMap() {
        mapView.removeAnnotations(mapView.annotations)
        
        let locations = (UIApplication.shared.delegate as? AppDelegate)?.studentLocations ?? []
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in locations {
            
            let lat = CLLocationDegrees(studentLocation.latitude ?? 0)
            let long = CLLocationDegrees(studentLocation.longitude ?? 0)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .gray
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            OpeningSafari(enteredLink: ((view.annotation?.subtitle) ?? nil) ?? "").open()
        }
    }

}
