//
//  ProgressHUDProtocol.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 03/05/23.
//

import Foundation

protocol ProgressShowable {

   func showProgress(_ title: String?)
   func hideProgress(completion: (() -> Void)?)

}
