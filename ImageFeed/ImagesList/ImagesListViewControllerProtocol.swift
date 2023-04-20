//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 17.04.2023.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    var tableView: UITableView! { get }
    var alertProvider: AlertOkButtonProvider? { get }
    func configure(_ presenter: ImagesListPresenterProtocol)
}
