//
//  PhotoPickerServiceErrors.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 15/06/23.
//

import Foundation

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
