//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Anton Reynikov on 11.04.2023.
//

import ImageFeed
import Foundation
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.ProfileViewControllerProtocol?
    var callLogoutAction: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logoutAction(viewController: UIViewController) {
        callLogoutAction = true
    }
}
