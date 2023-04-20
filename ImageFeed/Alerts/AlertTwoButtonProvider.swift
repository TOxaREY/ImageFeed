//
//  AlertTwoButtonProvider.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 23.03.2023.
//

import UIKit


struct AlertTwoButtonProvider {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func show(title: String, message: String, yesButtonTitle: String, noButtonTitle: String, action: @escaping () -> ()) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: yesButtonTitle, style: .default) { _ in
            action()
        }
        let actionNo = UIAlertAction(title: noButtonTitle, style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
