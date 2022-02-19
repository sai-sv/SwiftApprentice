//
//  WebImageView.swift
//  VKDemo
//
//  Created by Admin on 29.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    
    private var currentImageURL: String?
    
    func set(imageURL: String?) {
        
        currentImageURL = imageURL
        
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            //print(#function + " load image from cache")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil, let data = data, let response = response {                
                DispatchQueue.main.async {
                    self?.handleLoadedData(data: data, response: response)
                }
            }
        }.resume()
    }
    
    private func handleLoadedData(data: Data, response: URLResponse) {
        guard let url = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
        
        if url.absoluteString == currentImageURL {
            self.image = UIImage(data: data)
        }
    }
}
