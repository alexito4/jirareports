//
//  JIRA.swift
//  jirareports
//
//  Created by Alejandro Martinez on 12/01/2017.
//  Copyright © 2017 Alejandro Martinez. All rights reserved.
//

import Foundation

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
