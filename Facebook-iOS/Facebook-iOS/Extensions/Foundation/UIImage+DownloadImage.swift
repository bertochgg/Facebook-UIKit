//
//  UIImage+DownloadImage.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 15/05/23.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
}
