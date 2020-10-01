//
//  Response.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-30.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
