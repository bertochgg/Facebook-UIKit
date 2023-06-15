//
//  PhotoPickerService.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 15/06/23.
//
import PhotosUI
import UIKit

final class PhotoPickerService: NSObject, PhotoPickerServiceProtocol {
    weak var photoPickerDelegate: PhotoPickerServiceDelegate?
    
    private let imagePickerController = UIImagePickerController()
    
    init(delegate: PhotoPickerServiceDelegate?) {
        super.init()
        self.photoPickerDelegate = delegate
        self.imagePickerController.delegate = self
    }
    
    // Checks if there is a camera on device / Also check camera status
    func isCameraAvailable(completion: @escaping (Bool) -> Void) {
        completion(UIImagePickerController.isSourceTypeAvailable(.camera))
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
    
    // This is to present camera UI
    func presentImagePicker(at viewController: UIViewController, imagesSource: UIImagePickerController.SourceType) {
        imagePickerController.sourceType = imagesSource
        viewController.present(imagePickerController, animated: true)
    }
    
}

extension PhotoPickerService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoPickerDelegate?.imagePickerServiceDidPick(service: self, didPickImage: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        photoPickerDelegate?.imagePickerServiceDidCancel(service: self)
        picker.dismiss(animated: true, completion: nil)
    }
}
