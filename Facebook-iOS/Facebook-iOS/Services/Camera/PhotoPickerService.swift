//
//  PhotoPickerService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 15/06/23.
//
import PhotosUI
import UIKit

enum ImagePickerServiceError: Error {
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

protocol ImagePickerServiceDelegate: AnyObject {
    func imagePickerService(service: ImagePickerServiceProtocol, didPickImage image: UIImage?)
    func imagePickerService(service: ImagePickerServiceProtocol, didFailWithError error: Error)
    func imagePickerServiceDidCancel(service: ImagePickerServiceProtocol)
}

protocol ImagePickerServiceProtocol: AnyObject {
    var delegate: ImagePickerServiceDelegate? { get set }

    func isCameraAvailable(completion: @escaping (Bool) -> Void)
    func requestCameraAccess(completion: @escaping (Bool, Error?) -> Void)
    func checkPhotoLibraryAuthorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus
    func requestPhotoLibraryAuthorization(for accessLevel: PHAccessLevel, completion: @escaping (PHAuthorizationStatus) -> Void)
    func presentImagePicker(at viewController: UIViewController, imagesSource: UIImagePickerController.SourceType)
}
