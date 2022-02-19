//
//  NetworkService.swift
//  VKDemo
//
//  Created by Admin on 27.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation

// TODO: добавить обработку ошибок

protocol NetworkService: class {
    typealias CompletionHandler = (Result<Data, Error>) -> Void
    
    func request(url: String, completion: @escaping CompletionHandler)
    func request(request: URLRequest, completion: @escaping CompletionHandler)
}

class BaseNetworkService: NetworkService {
    
    private var configuration: URLSessionConfiguration
    private lazy var session: URLSession = { [unowned self] in
        return URLSession(configuration: self.configuration)
        }()
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.configuration = configuration
    }
    
    func request(url: String, completion: @escaping CompletionHandler) {
        
        guard let url = URL(string: url) else { return }
        
        let request = URLRequest(url: url)
        self.request(request: request, completion: completion)
    }
    
    func request(request: URLRequest, completion: @escaping CompletionHandler) {
        let task = self.dataTask(request: request, completion: completion)
        task.resume()
    }
    
    private func dataTask(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    
                    let error = NSError(domain: "com.sais", code: 1, userInfo: nil)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.sais", code: 2, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        return task
    }
}
