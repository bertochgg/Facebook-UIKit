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
    
    weak var signInView: SignInView?
    
    override func loadView() {
        // exampleUI()
        let signInView = SignInView(frame: .zero)
        view.addSubview(signInView)
        signInView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            signInView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            signInView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        signInView.setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
//    private func exampleUI() {
//        let background: UIImageView = {
//            let image = UIImageView()
//            image.image = UIImage(named: "Login")
//            image.alpha = 0.5
//            return image
//        }()
//        view.addSubview(background)
//
//        background.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            background.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//            background.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            background.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            background.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//        ])
//    }
    
}
