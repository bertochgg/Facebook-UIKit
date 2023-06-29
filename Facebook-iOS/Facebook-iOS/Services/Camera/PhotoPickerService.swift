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
        config.selectionLimit = 1
        config.filter = .images
        
        DispatchQueue.main.async {
            let photoPickerViewController = PHPickerViewController(configuration: config)
            photoPickerViewController.delegate = self
            viewController.present(photoPickerViewController, animated: true)
        }
    }
    
    // This is to present camera UI
    func presentCamera(at viewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        viewController.present(imagePicker, animated: true)
    }
}

extension PhotoPickerService: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }

        results.first?.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] object, error in
            if let error = error {
                print("PHPickerResult loading failed with error: \(error)")
                self?.photoPickerDelegate?.imagePickerServiceDidError(didFailWithError: PhotoPickerServiceError.photoPickedError)
            } else if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.photoPickerDelegate?.imagePickerServiceDidPick(didPickImage: image)
                    self?.photoPickerDelegate?.imagePickerServiceDidPickForUpdate(didPickImage: image)
                }
            }
        })
    }
}

extension PhotoPickerService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            self.photoPickerDelegate?.imagePickerServiceDidError(didFailWithError: PhotoPickerServiceError.photoPickedError)
            return
        }
        DispatchQueue.main.async {
            self.photoPickerDelegate?.imagePickerServiceDidPick(didPickImage: image)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
