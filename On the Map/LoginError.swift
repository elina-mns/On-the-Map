//
//  LoginError.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-30.
//

import Foundation

enum LoginError: LocalizedError {
    case userNotFound
    
    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "User is not found"
        }
    }
}
