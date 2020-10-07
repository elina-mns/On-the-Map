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
        
        case session
        case publicUserData(userId: String)
        case studentLocations
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "/session"
            case .studentLocations: return Endpoints.base + "/StudentLocation"
            case let .publicUserData(userId): return Endpoints.base + "/users/" + "\(userId)"
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
        return taskForGETRequest(url: urlComps.url!, responseType: responseType, completion: completion)
        
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL,
                                                          responseType: ResponseType.Type,
                                                          completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let result = url
        let task = URLSession.shared.dataTask(with: result) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseWithoutUselessSymbols = String(data: data, encoding: .utf8)?.replacingOccurrences(of: ")]}\'\n", with: "") ?? ""
                let correctData = responseWithoutUselessSymbols.data(using: .utf8)!
                let responseObject = try decoder.decode(ResponseType.self, from: correctData)
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
        taskForGETRequest(url: Endpoints.studentLocations.url, query: request, responseType: StudentLocations.self) { response, error in
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
    
    class func login(username: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let body = UdacityLogin(username: username, password: password)
        taskForPOSTRequest(url: Endpoints.session.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                if response.account.registered {
                    completion(response.account.key, nil)
                } else {
                    completion(nil, LoginError.userNotFound)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
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
        let urlString = Endpoints.studentLocations.stringValue + objectId
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
    
    class func postingStudentLocation(studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.studentLocations.url, responseType: PostingSL.self, body: studentLocation)
        { response, error in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func fetchUserInfo(userId: String, completion: @escaping (User?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.publicUserData(userId: userId).url, responseType: User.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}


