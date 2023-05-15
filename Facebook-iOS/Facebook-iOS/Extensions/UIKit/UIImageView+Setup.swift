//
//  UIImageView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 11/05/23.
//

import UIKit

extension UIImageView {
    func setupImageView(image: UIImage?,
                        radius: CGFloat,
                        borderWidth: CGFloat,
                        borderColor: UIColor) {
        guard let safeImage = image else {
            return
        }

        self.image = safeImage
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
