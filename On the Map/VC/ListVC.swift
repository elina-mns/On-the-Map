//
//  ListVC.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-30.
//

import UIKit

class ListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapPin = UIBarButtonItem()
        mapPin.image = UIImage(systemName: "mappin")
        navigationItem.leftBarButtonItem = mapPin
        
        let reverseButton = UIBarButtonItem()
        reverseButton.image = UIImage(systemName: "goforward")
        navigationItem.rightBarButtonItem = reverseButton
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
