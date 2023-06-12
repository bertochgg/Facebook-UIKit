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
    
    override func loadView() {
        self.view = createPostView
        navigationItem.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
