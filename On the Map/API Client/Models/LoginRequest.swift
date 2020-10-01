//
//  LoginRequest.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-30.
//

import Foundation

struct UdacityLogin: Codable {
    let udacity: LoginRequest
    
    init(username: String, password: String) {
        self.udacity = LoginRequest(username: username, password: password)
    }
}

struct LoginRequest: Codable {
    
    let username: String
    let password: String
}
