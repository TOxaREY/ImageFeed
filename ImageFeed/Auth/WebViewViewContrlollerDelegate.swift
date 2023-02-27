//
//  WebViewViewContrlollerDelegate.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 22.02.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController,
                                didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
