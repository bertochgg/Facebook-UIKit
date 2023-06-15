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
}

protocol CreatePostViewModelProtocol: AnyObject {
    var delegate: CreatePostViewModelDelegate? { get set }
    var photoPickerDelegate: PhotoPickerServiceDelegate? { get set }
    func fetchProfileData()
    func addPlaceholderElement()
    func addNewImageElement(at viewController: UIViewController, imagesSource: UIImagePickerController.SourceType)
}

final class CreatePostViewModel {
    weak var delegate: CreatePostViewModelDelegate?
    weak var photoPickerDelegate: PhotoPickerServiceDelegate?
    private let profileNetworkService: ProfileNetworkServiceProtocol = ProfileNetworkService()
    private let photoPickerService: PhotoPickerServiceProtocol?
    
    init() {
        photoPickerService = PhotoPickerService(delegate: photoPickerDelegate)
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
    
    func addNewImageElement(at viewController: UIViewController, imagesSource: UIImagePickerController.SourceType) {
        photoPickerService?.presentImagePicker(at: viewController, imagesSource: imagesSource)
    }
    
}
