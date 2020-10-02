//
//  ListVC.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-30.
//

import UIKit


class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    var locations: [[String : Any]] {
        (UIApplication.shared.delegate as? AppDelegate)?.hardCodedLocations ?? []
    }
    
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
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let location = self.locations[indexPath.row]
        let firstName = location["firstName"] as? String ?? ""
        let lastName = location["lastName"] as? String ?? ""
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.imageView?.image = UIImage(systemName: "mappin")
        return cell
    }

}
