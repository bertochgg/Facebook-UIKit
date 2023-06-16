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
}

protocol CreatePostViewModelProtocol: AnyObject {
    var delegate: CreatePostViewModelDelegate? { get set }
    var photoPickerDelegate: PhotoPickerServiceDelegate? { get set }
    func fetchProfileData()
    
    func addPlaceholderElement()
    func addNewImageElement(at viewController: UIViewController)
    func addNewImageElementFromCamera()
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
        photoPickerService?.isCameraAvailable(completion: { available, error in
            if available {
                self.photoPickerService?.presentImagePicker(at: viewController)
            } else if let error = error {
                print("No entre")
                self.delegate?.didCheckCameraAvailabilityWithError(error: error)
            }
        })
        
    }
    
    func addNewImageElementFromCamera() {
        photoPickerService?.isCameraAvailable(completion: { available, error in
            if available {
                print("si entre a la camara :3")
            } else if let error = error {
                print("No entre")
                self.delegate?.didCheckCameraAvailabilityWithError(error: error)
            }
        })
    }
    
}

extension CreatePostViewModel: PhotoPickerServiceDelegate {
    func imagePickerServiceDidPick(didPickImage image: UIImage?) {
        
    }
    
    func imagePickerServiceDidError(didFailWithError error: PhotoPickerServiceError) {
        
    }
    
    func imagePickerServiceDidCancel() {
        
    }
}
