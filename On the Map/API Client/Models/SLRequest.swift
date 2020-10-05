//
//  SLRequest.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-10-02.
//

import Foundation

struct StudentLocationRequest: URLQueriesProviding {
    let limit: String?
    let skip: Int?
    let order: String?
    let uniqueKey: String?
    
    init() {
        limit = nil
        skip = nil
        order = nil
        uniqueKey = nil
    }
    
    func toURLQuery() -> [URLQueryItem] {
        var queries = [URLQueryItem]()
        if let limit = limit {
            queries.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        if let skip = skip {
            queries.append(URLQueryItem(name: "skip", value: "\(skip)"))
        }
        if let order = order {
            queries.append(URLQueryItem(name: "order", value: "\(order)"))
        }
        if let uniqueKey = uniqueKey {
            queries.append(URLQueryItem(name: "uniqueKey", value: "\(uniqueKey)"))
        }
        return queries
    }
}
