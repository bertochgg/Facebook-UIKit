//
//  SignInViewController.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/15/22.
//

import UIKit

final class SignInViewController: UIViewController {
    
    var viewModel: SignInViewModel?
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // exampleUI()
        setupLayout()
    }
    
    private func exampleUI() {
        let background: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "Login")
            image.alpha = 0.5
            return image
        }()
        view.addSubview(background)
        
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
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
            logoImage.image = UIImage(named: "facebook")
            logoImage.contentMode = .scaleAspectFit
            return logoImage
        }()
        
        stackView.addArrangedSubview(fbLogo)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 3),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalToConstant: 130),
            stackView.heightAnchor.constraint(equalToConstant: 165)
        ])
        
        let fbLoginButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "fb-circle-logo"), for: .normal)
            button.setTitle("Continue with Facebook", for: .normal)
            button.titleLabel?.font = UIFont.robotoBoldItalic24
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 0)
            button.contentHorizontalAlignment = .center
            button.layer.cornerRadius = 26
            button.backgroundColor = UIColor(hex: "#1877f2")
            return button
        }()
        
        view.addSubview(fbLoginButton)
        
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fbLoginButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            fbLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            fbLoginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 44),
            fbLoginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -44),
            fbLoginButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        
    }
    
}
