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
}

final class CreatePostViewModel {
    weak var delegate: CreatePostViewModelDelegate?
    weak var photoPickerDelegate: PhotoPickerServiceDelegate?
    private let profileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    private let photoPickerService: PhotoPickerServiceProtocol?
    
    init() {
        photoPickerService = PhotoPickerService(delegate: photoPickerDelegate)
        photoPickerService?.photoPickerDelegate = self
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
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                self.delegate?.didReceiveDeniedAccessToLibrary(error: PhotoPickerServiceError.photoLibraryAccessDenied)
            case .authorized:
                self.photoPickerService?.presentImagePicker(at: viewController)
                
            case .limited:
                break
            @unknown default:
                break
            }
        })
    }
    
    func addNewImageElementFromCamera(at viewController: UIViewController) {
        photoPickerService?.isCameraAvailable { available, error in
            if available {
                print("si entre a la camara :3")
                self.photoPickerService?.requestCameraAccess { permission, error in
                    if permission {
                        // show camera ui
                        DispatchQueue.main.async {
                            self.photoPickerService?.presentCamera(at: viewController)
                        }
                    } else if let error = error {
                        self.delegate?.didReceiveDeniedAccessToCamera(error: error)
                    }
                }
            } else if let error = error {
                print("No entre")
                self.delegate?.didCheckCameraAvailabilityWithError(error: error)
            }
        }
    }
    
}

extension CreatePostViewModel: PhotoPickerServiceDelegate {
    func imagePickerServiceDidPick(didPickImage image: UIImage) {
        let viewModel = PhotoCollectionViewCellViewModel(image: image)
        self.delegate?.didAddNewImage(viewModel: viewModel)
    }
    
    func imagePickerServiceDidError(didFailWithError error: PhotoPickerServiceError) {
        self.delegate?.didReceiveDeniedAccessToLibrary(error: error)
    }
}
