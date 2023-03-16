//
//  AlertProvider.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 14.03.2023.
//

import Foundation
import UIKit


struct AlertProvider {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func show() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
