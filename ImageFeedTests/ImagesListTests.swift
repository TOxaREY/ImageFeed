//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Anton Reynikov on 18.04.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterLoadHeightForRowAt() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //when
        viewController.tableView(UITableView(), heightForRowAt: IndexPath())

        //then
        XCTAssertTrue(presenter.heightForRowAtCalled)
    }
    
    func testPresenterLoadNumberOfRowsInSection() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //when
        viewController.tableView(UITableView(), numberOfRowsInSection: Int())

        //then
        XCTAssertTrue(presenter.numberOfRowsInSectionCalled)
    }
    
    func testPresenterLoadWillDisplay() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //when
        viewController.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: IndexPath())

        //then
        XCTAssertTrue(presenter.willDisplayCalled)
    }
    
    func testPresenterLoadConfigCell() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        viewController.tableView = UITableView()
        viewController.tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
        
        //when
        viewController.tableView(viewController.tableView, cellForRowAt: IndexPath())

        //then
        XCTAssertTrue(presenter.configCellCalled)
    }
    
    func testPresenterLoadPrepare() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //when
        viewController.tableView(UITableView(), didSelectRowAt: IndexPath())

        //then
        XCTAssertTrue(presenter.prepareCalled)
    }
}

