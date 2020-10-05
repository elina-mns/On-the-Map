//
//  ListVC.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-30.
//

import UIKit


class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    var studentLocations: [StudentLocation] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        

        let mapPin = UIBarButtonItem()
        mapPin.image = UIImage(systemName: "mappin")
        navigationItem.leftBarButtonItem = mapPin
        
        let reverseButton = UIBarButtonItem()
        reverseButton.image = UIImage(systemName: "goforward")
        navigationItem.rightBarButtonItem = reverseButton
        Client.downloadStudentLocations(request: StudentLocationRequest()) { (locations, error) in
            guard !locations.isEmpty else {
                self.showFailureAlert(message: error?.localizedDescription ?? "")
                return
            }
            self.studentLocations = locations
            self.tableView.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let studentLocation = studentLocations[indexPath.row]
        let firstName = studentLocation.firstName
        let lastName = studentLocation.lastName
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.imageView?.image = UIImage(systemName: "mappin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        OpeningSafari(enteredLink: studentLocations[indexPath.row].mediaURL).open()
    }

}
