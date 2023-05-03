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
    
    weak var coordinator: (any AppCoordinatorProtocol)?
    
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
        self.coordinator?.didChangeNavigation()
    }
     
     func didSignInWithFailure() {
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
        self.viewModel.fetchSignInData()
    }
}
