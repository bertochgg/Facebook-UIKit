//
//  SignInView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 26/04/23.
//

import Foundation
import UIKit

class SignInView: UIView {
    
    func setupLayout() {
        let stackView = setupStackView()
        addSubview(stackView)
        let fbLogo = createFbLogo()
        stackView.addArrangedSubview(fbLogo)
        addStackViewConstraints(stackView: stackView)
        let fbLoginButton = setupFbLoginButton()
        addSubview(fbLoginButton)
        addFbLoginButtonConstraints(fbLoginButton: fbLoginButton)
    }
    
    private func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }

    private func addStackViewConstraints(stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 3),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalToConstant: 130),
            stackView.heightAnchor.constraint(equalToConstant: 165)
        ])
    }

    private func createFbLogo() -> UIImageView {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "facebook")
        logoImage.contentMode = .scaleAspectFit
        return logoImage
    }

    private func setupFbLoginButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "fb-circle-logo"), for: .normal)
        button.setTitle("Continue with Facebook", for: .normal)
        button.titleLabel?.font = UIFont.robotoBoldItalic24
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 26
        button.backgroundColor = UIColor(hexString: "#1877F2")
        return button
    }

    private func addFbLoginButtonConstraints(fbLoginButton: UIButton) {
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fbLoginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            fbLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            fbLoginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            fbLoginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),
            fbLoginButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
