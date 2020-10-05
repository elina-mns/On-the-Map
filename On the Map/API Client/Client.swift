//
//  Client.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-09-29.
//

import Foundation

class Client {
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case downloadStudentLocations
        case publicUserData
        case puttingSL
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .downloadStudentLocations: return Endpoints.base + "/StudentLocation"
            case .publicUserData: return Endpoints.base + "users/"
            case .puttingSL: return Endpoints.base + "/StudentLocation/"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable, Query: URLQueriesProviding>(url: URL,
                                                          query: Query? = nil,
                                                          responseType: ResponseType.Type,
                                                          completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let queryItems = query?.toURLQuery()
        var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        let task = URLSession.shared.dataTask(with: result) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func downloadStudentLocations(request: StudentLocationRequest, completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.downloadStudentLocations.url, query: request, responseType: StudentLocations.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let responseWithoutUselessSymbols = String(data: data, encoding: .utf8)?.replacingOccurrences(of: ")]}\'\n", with: "") ?? ""
            let correctData = responseWithoutUselessSymbols.data(using: .utf8)!
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: correctData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorObject = try decoder.decode(ErrorType.self, from: correctData)
                    DispatchQueue.main.async {
                        completion(nil, LoginError.custom(errorDescription: errorObject.error ?? ""))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = UdacityLogin(username: username, password: password)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                if response.account.registered {
                    completion(true, nil)
                } else {
                    completion(false, LoginError.userNotFound)
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            defer { completion() }
            if error != nil {
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func puttingStudentLocation(studentLocation: StudentLocation, objectId: String, completion: @escaping (Bool, Error?) -> Void) {
        let urlString = Endpoints.puttingSL.stringValue + objectId
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(studentLocation)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
                return
            }
            
            guard let data = data else {
                completion(false, nil)
                return
            }
            
            let decoder = JSONDecoder()
            let responseWithoutUselessSymbols = String(data: data, encoding: .utf8)?.replacingOccurrences(of: ")]}\'\n", with: "") ?? ""
            let correctData = responseWithoutUselessSymbols.data(using: .utf8)!
            let responseObject = try? decoder.decode(PuttingSL.self, from: correctData)
            completion(responseObject != nil, nil)
        }
        task.resume()
    }
}


