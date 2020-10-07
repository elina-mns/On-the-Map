//
//  UserResponse.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-10-06.
//

import Foundation

struct UserResponse: Codable {
    let user: User
}

struct User: Codable {
    let firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
