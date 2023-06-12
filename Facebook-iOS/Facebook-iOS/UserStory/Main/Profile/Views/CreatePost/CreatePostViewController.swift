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
    private let createPostViewModel = CreatePostViewModel()
    
    private lazy var closeAddPostButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(ImagesNames.closeCreatePostButtonImage, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeAddPostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addPostLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold14
        label.textColor = .black
        label.backgroundColor = .clear
        label.text = "Post"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold14
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
        configureBarButtonItems()
    }
    
    private func configureBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeAddPostButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addPostLabel)
    }
    
    @objc
    private func closeAddPostButtonTapped() {
        self.coordinator?.finish()
    }
    
    @objc
    private func addPostButtonTapped() {
        
    }
}
