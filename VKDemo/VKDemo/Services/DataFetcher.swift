//
//  DataFetcher.swift
//  VKDemo
//
//  Created by Admin on 27.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation

protocol DataFetcher: class {
    typealias ResponseHandler<T: Decodable> = (Result<T, Error>) -> Void
    
    func fetchData<T: Decodable>(url: String, response: @escaping ResponseHandler<T>)
    func fetchData<T: Decodable>(request: URLRequest, response: @escaping ResponseHandler<T>)
}

extension DataFetcher {
    
    func fetchData<T: Decodable>(url: String, response: @escaping ResponseHandler<T>) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        self.fetchData(request: request, response: response)
    }
    
    func decodeJSONData<T: Decodable>(type: T.Type, from data: Data) -> T? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch let error {
            print(error)
            return nil
        }
    }
}
