//
//  URLQueriesProviding.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-10-02.
//

import Foundation

protocol URLQueriesProviding {
    func toURLQuery() -> [URLQueryItem]
}
