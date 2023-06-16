//  PhotoPickerService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 15/06/23.
//
import PhotosUI
import UIKit

final class PhotoPickerService: NSObject, PhotoPickerServiceProtocol {
    weak var photoPickerDelegate: PhotoPickerServiceDelegate?
    
    init(delegate: PhotoPickerServiceDelegate?) {
        super.init()
        self.photoPickerDelegate = delegate
    }
    
    // Checks if there is a camera on device / Also check camera status
    func isCameraAvailable(completion: @escaping (Bool, PhotoPickerServiceError?) -> Void) {
        completion(UIImagePickerController.isSourceTypeAvailable(.camera), PhotoPickerServiceError.cameraNotAvailable)
    }
    
    // Shows Camera Access Alert
    func requestCameraAccess(completion: @escaping (Bool, PhotoPickerServiceError?) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { accessGranted in
            if accessGranted {
                completion(true, nil)
            } else {
                completion(false, PhotoPickerServiceError.cameraAccessDenied)
            }
        }
    }
    
    // Checks authorization status to access Library
    func checkPhotoLibraryAuthorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: mediaType)
    }
    
    // Shows Photo Library Access Alert
    func requestPhotoLibraryAuthorization(for accessLevel: PHAccessLevel, completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: accessLevel, handler: completion)
    }
    
    // This is to present picker UI
    func presentImagePicker(at viewController: UIViewController) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 2
        config.filter = .images
        
        let photoPickerViewController = PHPickerViewController(configuration: config)
        photoPickerViewController.delegate = viewController as? PHPickerViewControllerDelegate
        viewController.present(photoPickerViewController, animated: true)
    }
}
