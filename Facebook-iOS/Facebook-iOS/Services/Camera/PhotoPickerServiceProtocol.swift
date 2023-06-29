//
//  PhotoPickerServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 15/06/23.
//
import PhotosUI
import UIKit

protocol PhotoPickerServiceDelegate: AnyObject {
    func imagePickerServiceDidPick(didPickImage image: UIImage)
    func imagePickerServiceDidError(didFailWithError error: PhotoPickerServiceError)
    func imagePickerServiceDidPickForUpdate(didPickImage newImage: UIImage)
}

protocol PhotoPickerServiceProtocol: AnyObject {
    var photoPickerDelegate: PhotoPickerServiceDelegate? { get set }
    var isUpdatingExistingImage: Bool { get set }

    func isCameraAvailable(completion: @escaping (Bool, PhotoPickerServiceError?) -> Void)
    func requestCameraAccess(completion: @escaping (Bool, PhotoPickerServiceError?) -> Void)
    func checkPhotoLibraryAuthorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus
    func requestPhotoLibraryAuthorization(for accessLevel: PHAccessLevel, completion: @escaping (PHAuthorizationStatus) -> Void)
    func presentImagePicker(at viewController: UIViewController)
    func presentCamera(at viewController: UIViewController)
}
