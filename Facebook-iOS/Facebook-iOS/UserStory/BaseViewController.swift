//
//  BaseViewController.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 03/05/23.
//
import JGProgressHUD
import UIKit

class BaseViewController: UIViewController {
    private var progressHUD: JGProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension BaseViewController: ProgressShowable {
    func showProgress(_ title: String?) {
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = title
        hud.show(in: self.view)
        progressHUD = hud
    }
    
    func hideProgress() {
        if let hud = progressHUD {
            hud.dismiss(animated: true)
            progressHUD = nil
        }
    }
    
}
