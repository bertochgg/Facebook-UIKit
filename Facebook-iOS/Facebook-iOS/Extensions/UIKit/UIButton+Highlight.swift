//
//  UIButton+Highlight.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 13/06/23.
//

import UIKit

extension UIButton {
    func highlightWithColorChange(to color: UIColor, revertAfter delay: TimeInterval, revertColor: UIColor) {
        let highlightedImage = self.currentImage?.withTintColor(color, renderingMode: .alwaysOriginal)
        self.setImage(highlightedImage, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let revertImage = self.currentImage?.withTintColor(revertColor, renderingMode: .alwaysOriginal)
            self.setImage(revertImage, for: .normal)
        }
    }
}
