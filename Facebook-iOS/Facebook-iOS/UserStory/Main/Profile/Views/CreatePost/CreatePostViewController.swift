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
    private let createPostViewModel: CreatePostViewModelProtocol?
    
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
        button.isEnabled = false
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
    
    init(createPostViewModel: CreatePostViewModelProtocol?) {
        self.createPostViewModel = createPostViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureBarButtonItems()
        print("Current count: \(String(describing: navigationController?.viewControllers.count))")
        
        createPostViewModel?.delegate = self
        createPostViewModel?.fetchProfileData()
        createPostViewModel?.addPlaceholderElement()
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
        let isMessageEmpty = createPostView.isMessageTextViewEmpty()
        let isPhotoCarouselEmpty = createPostView.isPhotoCarouselEmpty()
        
        if isMessageEmpty || isPhotoCarouselEmpty {
            print("Cannot create post - UI elements are empty")
        } else {
            print("Creating Post")
        }
    }

}

extension CreatePostViewController: CreatePostViewModelDelegate {
    func didUpdateImage(viewModels: [PhotoCollectionViewCellViewModel]) {
        updateView(with: viewModels)
    }

    func didRemoveImage(viewModels: [PhotoCollectionViewCellViewModel]) {
        updateView(with: viewModels)
    }

    func didAddNewImage(viewModels: [PhotoCollectionViewCellViewModel]) {
        updateView(with: viewModels)
    }
    
    func didAddPlaceholder(viewModels: [PhotoCollectionViewCellViewModel]) {
        updateView(with: viewModels)
    }
    
    func didDisplayProfileData(viewModel: CreatePostDataViewModel) {
        createPostView.configure(with: viewModel)
    }
    
    // Errors
    func didCheckCameraAvailabilityWithError(error: PhotoPickerServiceError) {
        presentAccessErrorAlerts(title: "Camera not available", message: error.localizedString)
    }
    
    func didReceiveDeniedAccessToCamera(error: PhotoPickerServiceError) {
        presentAccessErrorAlerts(title: "Camera access denied", message: error.localizedString)
    }
    
    func didReceiveDeniedAccessToLibrary(error: PhotoPickerServiceError) {
        presentAccessErrorAlerts(title: "An error ocurred", message: error.localizedString)
    }
    
    private func presentAccessErrorAlerts(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func updateView(with viewModels: [PhotoCollectionViewCellViewModel]) {
        self.createPostView.applySnapshot(with: viewModels)
    }
}

extension CreatePostViewController: PhotoCollectionViewCellDelegate {
    func didTapUpdateImageButton(viewModel: PhotoCollectionViewCellViewModel?) {
        createPostViewModel?.editImageElement(at: self, viewModel: viewModel)
    }

    func didTapCancelImageButton(cell: PhotoCollectionViewCell) {
        if let viewModel = cell.viewModel {
            createPostViewModel?.removeImageElement(for: viewModel)
        }
    }
    
    func didTapAddPhotoButton() {
        imagePickerOptionsActionSheet()
    }
    
    private func imagePickerOptionsActionSheet() {
        let actionSheet = UIAlertController(title: "Select photo", message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { _ in
            self.createPostViewModel?.addNewImageElementFromCamera(at: self)
        }
        
        let galleryAction = UIAlertAction(title: "Select from Gallery", style: .default) { _ in
            self.createPostViewModel?.addNewImageElement(at: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
