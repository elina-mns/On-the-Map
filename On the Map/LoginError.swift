//
//  LoginError.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-30.
//

import Foundation

enum LoginError: LocalizedError {
    case userNotFound
    case custom(errorDescription: String)
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User is not found"
        case let .custom(errorDescription):
            return errorDescription
        }
    }
}
