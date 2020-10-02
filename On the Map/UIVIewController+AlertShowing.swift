//
//  UIVIewController+AlertShowing.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-10-01.
//

import UIKit

extension UIViewController {
    func showFailureAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
