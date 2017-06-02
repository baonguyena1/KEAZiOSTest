//
//  Downloader.swift
//  KEAZiOSTest
//
//  Created by Bao Nguyen on 6/2/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
}

enum Result<T> {
    case success(T)
    case error(APIError)
}

struct Downloader {
    
    private let session: URLSession
    
    init() {
        self.init(configuration: .default)
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    typealias TaskCompletionHandler = (Result<Int>) -> ()
    
    func downloadTask(with request: URLRequest, completionHandler completion: @escaping TaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.error(.requestFailed))
                Logger.log(message: "error = \(error!.localizedDescription)", event: .e)
                return
            }
            if httpResponse.statusCode != 200 {
                completion(.error(.responseUnsuccessful))
                return
            }
            
            completion(.success(httpResponse.statusCode))
        }
        
        return task
    }
}

