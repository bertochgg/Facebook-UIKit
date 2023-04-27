//
//  SignInViewController.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/15/22.
//

import UIKit

final class SignInViewController: UIViewController {
    
    private let signInView = SignInView()
    private var viewModel: SignInViewModelProtocol?
    var coordinator: AppCoordinator?
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        viewModel?.fetchSignInData()
        
    }
    
}

extension SignInViewController: SignInDelegate {
    
    func didSignIn() {
        
    }
    
}
