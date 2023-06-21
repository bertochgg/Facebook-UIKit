//
//  CreatePostViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//
import Photos
import PhotosUI
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
        createPostView.delegate = self
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
        createPostViewModel.addPlaceholderElement()
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
    
    func didAddNewImage(viewModel: PhotoCollectionViewCellViewModel) {
        DispatchQueue.main.async {
            self.createPostView.viewModels.append(viewModel)
            self.createPostView.applySnapshot()
        }
        
        if let originalPlaceholderIndex = createPostView.viewModels.firstIndex(where: { $0.isPlaceholder }) {
            let originalPlaceholder = createPostView.viewModels.remove(at: originalPlaceholderIndex)
            DispatchQueue.main.async {
                self.createPostView.viewModels.append(originalPlaceholder)
                self.createPostView.applySnapshot()
            }
        }
    }
    
    func didAddPlaceholder(viewModel: PhotoCollectionViewCellViewModel) {
        createPostView.viewModels.append(viewModel)
        createPostView.applySnapshot()
        
        if let originalPlaceholderIndex = createPostView.viewModels.firstIndex(where: { $0.isPlaceholder }) {
            let originalPlaceholder = createPostView.viewModels.remove(at: originalPlaceholderIndex)
            
            createPostView.viewModels.append(originalPlaceholder)
            createPostView.applySnapshot()
        }
    }
    
    func didDisplayProfileData(viewModel: CreatePostDataViewModel) {
        createPostView.configure(with: viewModel)
    }
    
    // Errors
    func didCheckCameraAvailabilityWithError(error: PhotoPickerServiceError) {
        let title = "Camera not available"
        let message = error.localizedString
        DispatchQueue.main.async {
            self.presentAccessErrorAlerts(title: title, message: message)
        }
    }
    
    func didReceiveDeniedAccessToCamera(error: PhotoPickerServiceError) {
        let title = "Camera access denied"
        let message = error.localizedString
        DispatchQueue.main.async {
            self.presentAccessErrorAlerts(title: title, message: message)
        }
    }
    
    func didReceiveDeniedAccessToLibrary(error: PhotoPickerServiceError) {
        let title = "An error ocurred"
        let message = error.localizedString
        DispatchQueue.main.async {
            self.presentAccessErrorAlerts(title: title, message: message)
        }
    }
    
    private func presentAccessErrorAlerts(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension CreatePostViewController: PhotoCollectionViewCellDelegate {
    func didTapAddPhotoButton(cell: PhotoCollectionViewCell) {
        imagePickerOptionsActionSheet()
    }
    
    private func imagePickerOptionsActionSheet() {
        let actionSheet = UIAlertController(title: "Select photo", message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { _ in
            self.createPostViewModel.addNewImageElementFromCamera(at: self)
        }
        
        let galleryAction = UIAlertAction(title: "Select from Gallery", style: .default) { _ in
            self.createPostViewModel.addNewImageElement(at: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
