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
    
    private let signInView = SignInView()
    
    override func loadView() {
        // super.loadView()
        // exampleUI()
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
