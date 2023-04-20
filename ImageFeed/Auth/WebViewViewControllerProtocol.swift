//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 07.04.2023.
//

import Foundation

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
