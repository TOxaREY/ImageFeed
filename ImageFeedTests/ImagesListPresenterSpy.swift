//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Anton Reynikov on 18.04.2023.
//

@testable import ImageFeed
import Foundation
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var willDisplayCalled: Bool = false
    var heightForRowAtCalled: Bool = false
    var numberOfRowsInSectionCalled: Bool = false
    var configCellCalled: Bool = false
    var prepareCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func configCell(for cell: ImageFeed.ImagesListCell, with indexPath: IndexPath) {
        configCellCalled = true
    }
    
    func willDisplay(forRowAt indexPath: IndexPath) {
        willDisplayCalled = true
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        heightForRowAtCalled = true
        return 0
    }
    
    func numberOfRowsInSection() -> Int {
        numberOfRowsInSectionCalled = true
        return 0
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepareCalled = true
    }
}
