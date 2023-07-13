//
//  CreatePostViewModel.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 09/06/23.
//

import Foundation
import UIKit

private enum Constants {
    static let defaultProfileImage = "https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg"
}

protocol CreatePostViewModelDelegate: AnyObject {
    func didDisplayProfileData(viewModel: CreatePostDataViewModel)
    func didAddPlaceholder(viewModels: [PhotoCollectionViewCellViewModel])
    func didAddNewImage(viewModels: [PhotoCollectionViewCellViewModel])
    func didRemoveImage(viewModels: [PhotoCollectionViewCellViewModel])
    func didUpdateImage(viewModels: [PhotoCollectionViewCellViewModel])
    
    func didCheckCameraAvailabilityWithError(error: PhotoPickerServiceError)
    func didReceiveDeniedAccessToCamera(error: PhotoPickerServiceError)
    func didReceiveDeniedAccessToLibrary(error: PhotoPickerServiceError)
}

protocol CreatePostViewModelProtocol: AnyObject {
    var delegate: CreatePostViewModelDelegate? { get set }
    func fetchProfileData()
    
    func addPlaceholderElement()
    func addNewImageElement(at viewController: UIViewController)
    func addNewImageElementFromCamera(at viewController: UIViewController)
    func removeImageElement(for viewModel: PhotoCollectionViewCellViewModel)
    func editImageElement(at viewController: UIViewController, viewModel: PhotoCollectionViewCellViewModel?)
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
        delegate?.didAddPlaceholder(viewModels: viewModels)
        
        if let originalPlaceholderIndex = viewModels.firstIndex(where: { $0.isPlaceholder }) {
            let originalPlaceholder = viewModels.remove(at: originalPlaceholderIndex)
            viewModels.append(originalPlaceholder)
        }
    }
    
    func addNewImageElement(at viewController: UIViewController) {
        self.photoPickerService?.requestPhotoLibraryAuthorization(for: .readWrite, completion: { permission  in
            switch permission {
            case .denied:
                self.delegate?.didReceiveDeniedAccessToLibrary(error: PhotoPickerServiceError.photoLibraryAccessDenied)
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
                self.delegate?.didCheckCameraAvailabilityWithError(error: error)
                return
            }
            
            self.photoPickerService?.requestCameraAccess { permission, error in
                guard let error = error else { return }
                guard permission else {
                    self.delegate?.didReceiveDeniedAccessToCamera(error: error)
                    return
                }
                
                DispatchQueue.main.async {
                    self.photoPickerService?.presentCamera(at: viewController)
                }
            }
        }
    }
    
    func removeImageElement(for viewModel: PhotoCollectionViewCellViewModel) {
        
        if let index = self.viewModels.firstIndex(of: viewModel) {
            self.viewModels.remove(at: index)
        }
        
        self.delegate?.didRemoveImage(viewModels: viewModels)
    }
    
    func editImageElement(at viewController: UIViewController, viewModel: PhotoCollectionViewCellViewModel?) {
        guard let viewModel = viewModel else { return }
        editingImageID = viewModel.id
        toggleUpdatingMode()
        self.photoPickerService?.presentImagePicker(at: viewController)
    }
    
    private func toggleUpdatingMode() {
        self.isUpdatingExistingImage.toggle()
    }
}

extension CreatePostViewModel: PhotoPickerServiceDelegate {
    func imagePickerServiceDidPick(didPickImage image: UIImage) {
        if isUpdatingExistingImage {
            guard let viewModelID = self.editingImageID else { return }
            let updateViewModel = PhotoCollectionViewCellViewModel(id: viewModelID, image: image)
            
            if let index = self.viewModels.firstIndex(of: updateViewModel) {
                self.viewModels[index] = updateViewModel
            }
            
            self.editingImageID = nil
            DispatchQueue.main.async {
                self.delegate?.didUpdateImage(viewModels: self.viewModels)
            }
            
            toggleUpdatingMode()
        } else {
            let viewModel = PhotoCollectionViewCellViewModel(image: image)
            viewModels.append(viewModel)
            
            if let originalPlaceholderIndex = viewModels.firstIndex(where: { $0.isPlaceholder }) {
                let originalPlaceholder = viewModels.remove(at: originalPlaceholderIndex)
                self.viewModels.append(originalPlaceholder)
            }
            
            DispatchQueue.main.async {
                self.delegate?.didAddNewImage(viewModels: self.viewModels)
            }
        }
    }
    
    func imagePickerServiceDidError(didFailWithError error: PhotoPickerServiceError) {
        self.delegate?.didReceiveDeniedAccessToLibrary(error: error)
    }
    
}
