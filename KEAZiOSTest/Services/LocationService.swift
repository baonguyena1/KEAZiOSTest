//
//  LocationService.swift
//  KEAZiOSTest
//
//  Created by Bao Nguyen on 6/2/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

protocol Postable {
    associatedtype T    // define generic in protocol
    func post(with jsonData: [String: Any], completion: @escaping (Result<T>) -> ())
}

struct LocationService: Postable {
    
    private let endpoint: String = "http://52.62.35.20:9000/api/Locations"
    private let downloader = Downloader()
    typealias updateLocatonCompletionHandler = (Result<Int>) -> ()
    
    func post(with jsonData: [String: Any], completion: @escaping updateLocatonCompletionHandler) {
        guard let url = URL(string: self.endpoint) else {
            Logger.log(message: "invalid URL.", event: .e)
            completion(.error(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let data = try? JSONSerialization.data(withJSONObject: jsonData)
        urlRequest.httpBody = data
        
        let task = downloader.downloadTask(with: urlRequest) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    completion(.error(error))
                case .success(let statusCode):
                    completion(.success(statusCode))
                }
            }
        }
        task.resume()

    }
}
