//
//  ViewController.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-29.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var loginwithFB: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        email.text = ""
        password.text = ""
        
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        email.isEnabled = !loggingIn
        password.isEnabled = !loggingIn
        login.isEnabled = !loggingIn
        loginwithFB.isEnabled = !loggingIn
    }
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = email.text else {
            showFailureAlert(message: "email required")
            return
        }
        guard let password = password.text else {
            showFailureAlert(message: "password required")
            return
        }
        setLoggingIn(true)
        
        Client.login(username: email, password: password) { success, error in
            if success {
                self.performSegue(withIdentifier: "didLogin", sender: self)
            } else if let error = error {
                self.showFailureAlert(message: error.localizedDescription)
            } else {
                self.showFailureAlert(message: "Error")
            }
            self.setLoggingIn(false)
        }
    }
    
    @IBAction func loginwithFBTapped() {
        performSegue(withIdentifier: "didLogin", sender: self)
    }
    
}

