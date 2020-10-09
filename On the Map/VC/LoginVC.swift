//
//  ViewController.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-29.
//

import UIKit
import FBSDKLoginKit

class LoginVC: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var loginwithFB: FBLoginButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isLogginIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        loginwithFB.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        email.text = ""
        password.text = ""
        
        if AccessToken.current !=  nil {
            self.performSegue(withIdentifier: "didLogin", sender: self)
        }
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
        // Request uniqKey
        Client.login(username: email, password: password) { uniqueKey, error in
            // If uniqKey presents
            if let uniqueKey = uniqueKey {
                UserInfo.uniqueKey = uniqueKey
                // Request userInfo
                Client.fetchUserInfo(userId: uniqueKey) { (userResponse, error) in
                    if let userResponse = userResponse {
                        UserInfo.firstName = userResponse.firstName ?? ""
                        UserInfo.lastName = userResponse.lastName ?? ""
                        UserInfo.isFromFacebook = false
                        self.performSegue(withIdentifier: "didLogin", sender: self)
                    } else {
                        self.showFailureAlert(message: "User not found")
                    }
                }
            } else if let error = error {
                self.showFailureAlert(message: error.localizedDescription)
            } else {
                self.showFailureAlert(message: "Error")
            }
            self.setLoggingIn(false)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        setLoggingIn(true)
        defer {
            setLoggingIn(false)
        }
        guard error == nil else {
            showFailureAlert(message: error?.localizedDescription ?? "")
            return
        }
        guard let result = result, !result.isCancelled else {
            showFailureAlert(message: "Login has been cancelled")
            return
        }
        Profile.loadCurrentProfile { (profile, error) in
            if let error = error {
                self.showFailureAlert(message: error.localizedDescription)
            } else {
                UserInfo.firstName = profile?.firstName ?? ""
                UserInfo.lastName = profile?.lastName ?? ""
                UserInfo.uniqueKey = profile?.userID ?? ""
                UserInfo.isFromFacebook = true
                self.dismiss(animated: true) {
                    self.performSegue(withIdentifier: "didLogin", sender: self)
                }
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}

