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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(ImagesNames.closeCreatePostButtonImage, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeAddPostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont.robotoBold14
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
        return button
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = tabBarController {
            let whiteBar = UIView(frame: tabBarController.tabBar.frame)
            whiteBar.backgroundColor = .white
            self.view.addSubview(whiteBar)
            self.view.bringSubviewToFront(whiteBar)
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureBarButtonItems()
        print("Current count: \(String(describing: navigationController?.viewControllers.count))")
    }
    
    private func configureBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeAddPostButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addPostButton)
    }
    
    private func highlightButton() {
        let highlightedImage = closeAddPostButton.currentImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        closeAddPostButton.setImage(highlightedImage, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.closeAddPostButton.setImage(self.closeAddPostButton.currentImage?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
    @objc
    private func closeAddPostButtonTapped() {
        highlightButton()
        self.coordinator?.finish()
    }
    
    @objc
    private func addPostButtonTapped() {
        print("Adding Post")
    }
}
