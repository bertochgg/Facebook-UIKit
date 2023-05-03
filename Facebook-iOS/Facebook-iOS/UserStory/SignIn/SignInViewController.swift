//
//  SignInViewController.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/15/22.
//
import FacebookLogin
import UIKit

final class SignInViewController: UIViewController {
    
    private let signInView = SignInView()
    private let viewModel: SignInViewModelProtocol
    
    weak var coordinator: AppCoordinator?
    
    init(viewModel: SignInViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        signInView.delegate = self
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

 extension SignInViewController: SignInViewModelDelegate {
    func didSignIn() {
        // self.viewModel.fetchSignInData()
    }
    
 }

extension SignInViewController: SignInViewDelegate {
    func signInButtonTapped() {
        self.viewModel.fetchSignInData()
    }
}
