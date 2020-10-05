//
//  StudentLocationAPI.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-10-02.
//

import Foundation

struct StudentLocation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
