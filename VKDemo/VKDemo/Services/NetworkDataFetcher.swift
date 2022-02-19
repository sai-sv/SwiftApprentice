//
//  NetworkDataFetcher.swift
//  VKDemo
//
//  Created by Admin on 27.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation

class NetworkDataFetcher: DataFetcher {
    
    private var networkService: NetworkService
    
    init(networkService: NetworkService = BaseNetworkService()) {
        self.networkService = networkService
    }
    
    func fetchData<T: Decodable>(request: URLRequest, response: @escaping ResponseHandler<T>) {
        networkService.request(request: request) { (result) in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                if let decodedData = self.decodeJSONData(type: T.self, from: data) {
                    response(.success(decodedData))
                }
            }
        }
    }
}
