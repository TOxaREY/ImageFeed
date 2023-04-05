//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 23.03.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
