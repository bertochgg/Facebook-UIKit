//
//  CreatePostViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//
import UIKit

private enum Constants {
    enum Errors {
        static let libraryAccessDenied = "Camera access denied"
        static let cameraNotFound = "Camera not found in the device"
        static let imagePickedError = "Image picked with invalid format"
        static let cameraAccessDenied = "Permission for camera denied"
    }
}

protocol CreatePostViewModelDelegate: AnyObject {
    func didDisplayProfileData(viewModel: CreatePostDataViewModel)
    func updateCollectionViewItems(with viewModels: [PhotoCollectionViewCellViewModel])
    func didValidatePost(isValid: Bool)

    func didReceivePhotoServiceError(title: String, error: PhotoPickerServiceError)
}

protocol CreatePostViewModelProtocol: AnyObject {
    var delegate: CreatePostViewModelDelegate? { get set }
    func fetchProfileData()
    
    func addPlaceholderElement()
    func addNewImageElement(at viewController: UIViewController)
    func addNewImageElementFromCamera(at viewController: UIViewController)
    func removeImageElement(for viewModel: PhotoCollectionViewCellViewModel)
    func editImageElement(at viewController: UIViewController, viewModel: PhotoCollectionViewCellViewModel?)
    func validatePost(textView: UITextView?)
}

final class CreatePostViewModel {
    weak var delegate: CreatePostViewModelDelegate?
    private let profileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    private let photoPickerService: PhotoPickerServiceProtocol?
    
    private var isUpdatingExistingImage: Bool = false
    private var viewModels: [PhotoCollectionViewCellViewModel] = []
    private var editingImageID: UUID?
    
    init(photoPickerService: PhotoPickerServiceProtocol) {
        self.photoPickerService = photoPickerService
        self.photoPickerService?.photoPickerDelegate = self
    }
}

extension CreatePostViewModel: CreatePostViewModelProtocol {
    func fetchProfileData() {
        profileNetworkService.fetchProfileData { [weak self] result in
            switch result {
            case .success(let userData):
                print("User data fetching successful")
                let displayData = CreatePostDataViewModel.transform(from: userData)
                self?.delegate?.didDisplayProfileData(viewModel: displayData)
            case .failure(let error):
                print("Error fetching user profile data: \(error)")
            }
        }
        
    }
    
    func addPlaceholderElement() {
        guard let placeHolderImage = ImagesNames.placeholderImage else { return }
        let viewModel = PhotoCollectionViewCellViewModel(image: placeHolderImage)
        viewModels.append(viewModel)
        delegate?.updateCollectionViewItems(with: viewModels)
    }
    
    func addNewImageElement(at viewController: UIViewController) {
        self.photoPickerService?.requestPhotoLibraryAuthorization(for: .readWrite, completion: { permission  in
            switch permission {
            case .denied:
                self.delegate?.didReceivePhotoServiceError(title: Constants.Errors.libraryAccessDenied, error: PhotoPickerServiceError.photoLibraryAccessDenied)
            case .authorized:
                self.photoPickerService?.presentImagePicker(at: viewController)
            default:
                break
            }
        })
    }
    
    func addNewImageElementFromCamera(at viewController: UIViewController) {
        photoPickerService?.isCameraAvailable { available, error in
            guard let error = error else { return }
            guard available else {
                self.delegate?.didReceivePhotoServiceError(title: Constants.Errors.cameraNotFound, error: error)
                return
            }
            
            self.photoPickerService?.requestCameraAccess { permission, error in
                guard let error = error else { return }
                guard permission else {
                    self.delegate?.didReceivePhotoServiceError(title: Constants.Errors.cameraAccessDenied, error: error)
                    return
                }
                
                self.photoPickerService?.presentCamera(at: viewController)
            }
        }
    }
    
    func removeImageElement(for viewModel: PhotoCollectionViewCellViewModel) {
        if let index = self.viewModels.firstIndex(of: viewModel) {
            self.viewModels.remove(at: index)
            print("View models amount: \(viewModels.count)")
        }
        
        self.delegate?.updateCollectionViewItems(with: viewModels)
    }
    
    func editImageElement(at viewController: UIViewController, viewModel: PhotoCollectionViewCellViewModel?) {
        guard let viewModel = viewModel else { return }
        editingImageID = viewModel.id
        toggleUpdatingMode()
        self.photoPickerService?.presentImagePicker(at: viewController)
    }
    
    func validatePost(textView: UITextView?) {
        let isCollectionViewEmpty = self.isCollectionViewEmpty()
        let isMessageTextViewEmpty = self.isMessageTextViewEmpty(textView: textView)
        let isValid = !(isCollectionViewEmpty && isMessageTextViewEmpty)
        delegate?.didValidatePost(isValid: isValid)
    }

    private func isCollectionViewEmpty() -> Bool {
        let isViewModelsEmpty = viewModels.isEmpty || (viewModels.count == 1 && viewModels.first?.isPlaceholder == true)
        return isViewModelsEmpty
    }

    private func isMessageTextViewEmpty(textView: UITextView?) -> Bool {
        return textView?.text.isEmpty ?? true
    }

    private func toggleUpdatingMode() {
        self.isUpdatingExistingImage.toggle()
    }
}

extension CreatePostViewModel: PhotoPickerServiceDelegate {
    func imagePickerServiceDidPick(didPickImage image: UIImage) {
        if isUpdatingExistingImage {
            guard let viewModelID = self.editingImageID else { return }
            
            if let index = self.viewModels.firstIndex(where: { $0.id == viewModelID }) {
                let updatedViewModel = PhotoCollectionViewCellViewModel(id: self.viewModels[index].id, image: image)
                self.viewModels[index] = updatedViewModel
                self.delegate?.updateCollectionViewItems(with: self.viewModels)
            }
            
            self.editingImageID = nil
            toggleUpdatingMode()
        } else {
            let viewModel = PhotoCollectionViewCellViewModel(image: image)
            viewModels.append(viewModel)
            
            if let originalPlaceholderIndex = viewModels.firstIndex(where: { $0.isPlaceholder }) {
                let originalPlaceholder = viewModels.remove(at: originalPlaceholderIndex)
                self.viewModels.append(originalPlaceholder)
            }
            
            self.delegate?.updateCollectionViewItems(with: self.viewModels)
        }
    }
    
    func imagePickerServiceDidError(didFailWithError error: PhotoPickerServiceError) {
        self.delegate?.didReceivePhotoServiceError(title: Constants.Errors.imagePickedError, error: error)
    }
    
    func imagePickerServiceDidCancel() {
        if isUpdatingExistingImage {
            editingImageID = nil
            toggleUpdatingMode()
        }
    }
}
