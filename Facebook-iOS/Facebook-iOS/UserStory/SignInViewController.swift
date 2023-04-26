//
//  SignInViewController.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/15/22.
//

import UIKit

final class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.alignment = .center
            stackView.distribution = .fill
            return stackView
        }()
        
        view.addSubview(stackView)
        
        let fbLogo: UIImageView = {
            let logoImage = UIImageView()
            logoImage.image = UIImage(named: "app-logo")
            logoImage.contentMode = .scaleAspectFit
            return logoImage
        }()
        
        let fbLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.text = "facebook"
            label.font = .ralewayBold28
            let gradient = getGradientLayer(bounds: label.bounds)
            label.textColor = gradientColor(bounds: label.bounds, gradientLayer: gradient)
            label.textColor = UIColor(red: 56 / 255, green: 76 / 255, blue: 255 / 255, alpha: 1)
            label.contentMode = .center
            label.numberOfLines = 1
            return label
        }()
        
        stackView.addArrangedSubview(fbLogo)
        stackView.addArrangedSubview(fbLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 130),
            stackView.heightAnchor.constraint(equalToConstant: 165)
        ])
        
        let fbLoginButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "facebook"), for: .normal)
            return button
        }()
        
        view.addSubview(fbLoginButton)
        
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fbLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46),
            fbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fbLoginButton.widthAnchor.constraint(equalToConstant: 234),
            fbLoginButton.heightAnchor.constraint(equalToConstant: 37)
        ])
        
    }
    
    func getGradientLayer(bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        // order of gradient colors
        gradient.colors = [UIColor(red: 56 / 255, green: 76 / 255, blue: 255 / 255, alpha: 1),
                           UIColor(red: 0 / 255, green: 163 / 255, blue: 255 / 255, alpha: 1)]
        // start and end points
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
    
    func gradientColor(bounds: CGRect, gradientLayer: CAGradientLayer) -> UIColor? {
        if let context = UIGraphicsGetCurrentContext(), let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsBeginImageContext(gradientLayer.bounds.size)
            gradientLayer.render(in: context)
            UIGraphicsEndImageContext()
            return UIColor(patternImage: image)
        }
        return nil
    }
}
