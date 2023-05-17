//
//  CustomProfileLabel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 17/05/23.
//

import UIKit

protocol CustomProfileLabelProtocol {
    func setupLabel(font: UIFont, textColor: UIColor, backgroundColor: UIColor)
}

class CustomProfileLabel: UILabel, CustomProfileLabelProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }

}
