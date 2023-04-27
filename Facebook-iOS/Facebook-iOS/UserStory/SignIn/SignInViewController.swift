//
//  SignInViewController.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/15/22.
//

import UIKit

final class SignInViewController: UIViewController {
    
    private let signInView = SignInView()
    private let viewModel: SignInViewModelProtocol
    
    var coordinator: AppCoordinator?
    
    init(viewModel: SignInViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchSignInData()
        
    }
    
}

extension SignInViewController: SignInViewModelDelegate {
    
    func didSignIn() {
        
    }
    
}
