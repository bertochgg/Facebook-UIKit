//
//  SignInViewController.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/15/22.
//
import UIKit

final class SignInViewController: BaseViewController {
    
    private let signInView = SignInView()
    private let viewModel: SignInViewModelProtocol = SignInViewModel()
    
    weak var coordinator: (any SignInCoordinatorProtocol)?
    
    override func loadView() {
        signInView.delegate = self
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
}

extension SignInViewController: SignInViewModelDelegate {
    func didSignIn() {  
        self.coordinator?.finish()
        self.hideProgress()
    }
    
    func didCancelSignIn() {
        self.hideProgress()
    }
    
    func didSignInWithFailure() {
        self.hideProgress()
        let alertController = UIAlertController(title: "Login Failed",
                                                message: "Something went wrong while trying to login",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension SignInViewController: SignInViewDelegate {
    func signInButtonTapped() {
        self.showProgress("Loading")
        self.viewModel.signInWithFacebook()
    }
}
