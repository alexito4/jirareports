//
//  JIRA.swift
//  jirareports
//
//  Created by Alejandro Martinez on 12/01/2017.
//  Copyright © 2017 Alejandro Martinez. All rights reserved.
//

import Foundation

public typealias JSON = Dictionary<String, AnyObject>

public enum Status: String {
    case open
    case reopened
    case inProgress = "In Progress"
    case inTechnicalReview = "In Technical Review"
    case resolved
    case readyForTesting = "Ready for Testing"
    case inTest = "In Test"
    case tested
    case closed
}

public class JIRA {

    let auth: String
    
    public init(basicAuth: String) {
        self.auth = basicAuth
    }
    
    public func search(withJQL jql: String) throws -> JSON {
        let endpoint = "https://workivate.atlassian.net/rest/api/latest/search"
        
        func searchUrl(with query: String) -> URL {
            var components = URLComponents(string: endpoint)!
            
            let jql = URLQueryItem(name: "jql", value: query)
            components.queryItems = [jql]
            
            return components.url!
        }
        
        let url = searchUrl(with: jql)
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        
        let authString = "Basic \(auth)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let (responseData, _, error) = session.synchronousDataTask(with: urlRequest)
        
        guard error == nil else {
            throw error!
        }
        
        guard let data = responseData else {
            throw "No data"
        }
  
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            
        return json ?? [:]
    }
    
}

extension String: Error {
    
    
}

extension URLSession {
    public func synchronousDataTask(with urlRequest: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: urlRequest) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
