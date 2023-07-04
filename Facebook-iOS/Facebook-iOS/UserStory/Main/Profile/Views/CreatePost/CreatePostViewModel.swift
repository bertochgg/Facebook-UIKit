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
    func didAddPlaceholder(viewModel: PhotoCollectionViewCellViewModel)
    func didAddNewImage(viewModel: PhotoCollectionViewCellViewModel)
    func didRemoveImage(viewModel: PhotoCollectionViewCellViewModel)
    func didUpdateImage(viewModel: PhotoCollectionViewCellViewModel)
    
    func didCheckCameraAvailabilityWithError(error: PhotoPickerServiceError)
    func didReceiveDeniedAccessToCamera(error: PhotoPickerServiceError)
    func didReceiveDeniedAccessToLibrary(error: PhotoPickerServiceError)
}

protocol CreatePostViewModelProtocol: AnyObject {
    var delegate: CreatePostViewModelDelegate? { get set }
    var photoPickerDelegate: PhotoPickerServiceDelegate? { get set }
    func fetchProfileData()
    
    func addPlaceholderElement()
    func addNewImageElement(at viewController: UIViewController)
    func addNewImageElementFromCamera(at viewController: UIViewController)
    func removeImageElement(for viewModel: PhotoCollectionViewCellViewModel)
    func editImageElement(at viewController: UIViewController)
    func toggleUpdatingMode()
}

final class CreatePostViewModel {
    weak var delegate: CreatePostViewModelDelegate?
    weak var photoPickerDelegate: PhotoPickerServiceDelegate?
    private let profileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    private let photoPickerService: PhotoPickerServiceProtocol?
    
    private var isUpdatingExistingImage: Bool = false
    
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
        delegate?.didAddPlaceholder(viewModel: viewModel)
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
        self.delegate?.didRemoveImage(viewModel: viewModel)
    }
    
    func editImageElement(at viewController: UIViewController) {
        self.photoPickerService?.presentImagePicker(at: viewController)
    }
    
    func toggleUpdatingMode() {
        self.isUpdatingExistingImage.toggle()
    }
}

extension CreatePostViewModel: PhotoPickerServiceDelegate {
    func imagePickerServiceDidPick(didPickImage image: UIImage) {
        let viewModel = PhotoCollectionViewCellViewModel(image: image)
        if isUpdatingExistingImage {
            self.delegate?.didUpdateImage(viewModel: viewModel)
        } else {
            self.delegate?.didAddNewImage(viewModel: viewModel)
        }
    }
    
    func imagePickerServiceDidError(didFailWithError error: PhotoPickerServiceError) {
        self.delegate?.didReceiveDeniedAccessToLibrary(error: error)
    }
    
}
