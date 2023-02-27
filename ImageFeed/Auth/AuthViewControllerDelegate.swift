//
//  AuthVIewControllerDelegate.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 22.02.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
