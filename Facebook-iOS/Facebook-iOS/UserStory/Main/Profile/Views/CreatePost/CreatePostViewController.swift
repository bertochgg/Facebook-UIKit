//
//  CreatePostViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    weak var coordinator: (any CreatePostCoordinatorProtocol)?
    private let createPostView = CreatePostView()
    private let createPostViewModel: CreatePostViewModelProtocol = CreatePostViewModel()
    
    private lazy var closeAddPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(ImagesNames.closeCreatePostButtonImage, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeAddPostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = .robotoBold14
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoBold14
        label.textColor = .black
        label.backgroundColor = .clear
        label.text = "Create Post"
        return label
    }()
    
    override func loadView() {
        self.view = createPostView
        navigationItem.titleView = titleLabel
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureBarButtonItems()
        print("Current count: \(String(describing: navigationController?.viewControllers.count))")
        
        createPostViewModel.delegate = self
        createPostViewModel.fetchProfileData()
    }
    
    private func configureBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeAddPostButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addPostButton)
    }
    
    @objc
    private func closeAddPostButtonTapped() {
        self.coordinator?.finish()
    }
    
    @objc
    private func addPostButtonTapped() {
        print("Adding Post")
    }
}

extension CreatePostViewController: CreatePostViewModelDelegate {
    func didDisplayProfileData(viewModel: CreatePostDataViewModel) {
        createPostView.configure(with: viewModel)
    }
}
