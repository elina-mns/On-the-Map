//
//  ListVC.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-30.
//

import UIKit


class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    var studentLocations: [StudentLocation] {
        (UIApplication.shared.delegate as? AppDelegate)?.studentLocations ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        

        let mapPin = UIBarButtonItem(image: UIImage(systemName: "mappin"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(showEnterLocationVC))
        
        let reverseButton = UIBarButtonItem(image: UIImage(systemName: "goforward"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(reload))
        navigationItem.rightBarButtonItems = [mapPin, reverseButton]
        reload()
       
    }
    
    @objc func reload() {
        (UIApplication.shared.delegate as? AppDelegate)?.reload(completion: { (error) in
            guard let error = error else {
                self.tableView.reloadData()
                return
            }
            self.showFailureAlert(message: error.localizedDescription)
        })
    }
    
    @objc func showEnterLocationVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "EnterLocation") as! EnterLocationVC
        self.present(newViewController, animated: true, completion: nil)
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
