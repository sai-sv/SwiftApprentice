//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Sergei Sai on 11.02.2022.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let task = URLSession.shared.downloadTask(with: url) { [weak self] url, _, error in
            if error == nil, let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
        task.resume()
        return task
    }
}
