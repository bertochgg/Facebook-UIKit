//
//  PhotoPickerServiceProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 15/06/23.
//
import PhotosUI
import UIKit

enum PhotoPickerServiceError: Error {
    case cameraNotAvailable
    case cameraAccessDenied
    case photoLibraryAccessDenied
    
    var localizedString: String {
        switch self {
        case .cameraNotAvailable:
            return "No camera was found, please check if your device has this capability."
        case .cameraAccessDenied:
            return "Camera access denied, if you want to access the camera please change access settings."
        case .photoLibraryAccessDenied:
            return "Photo library access denied, if you want to access the photo library please change access settings."
        }
    }
}

protocol PhotoPickerServiceDelegate: AnyObject {
    func imagePickerServiceDidPick(service: PhotoPickerServiceProtocol, didPickImage image: UIImage?)
    func imagePickerServiceDidError(service: PhotoPickerServiceProtocol, didFailWithError error: Error)
    func imagePickerServiceDidCancel(service: PhotoPickerServiceProtocol)
}

protocol PhotoPickerServiceProtocol: AnyObject {
    var photoPickerDelegate: PhotoPickerServiceDelegate? { get set }

    func isCameraAvailable(completion: @escaping (Bool) -> Void)
    func requestCameraAccess(completion: @escaping (Bool, PhotoPickerServiceError?) -> Void)
    func checkPhotoLibraryAuthorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus
    func requestPhotoLibraryAuthorization(for accessLevel: PHAccessLevel, completion: @escaping (PHAuthorizationStatus) -> Void)
    func presentImagePicker(at viewController: UIViewController, imagesSource: UIImagePickerController.SourceType)
}
