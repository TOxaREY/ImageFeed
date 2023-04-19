//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Anton Reynikov on 11.04.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterLoadViews() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profile: Profile(username: "test", name: "test", loginName: "test", bio: "test"))
        viewController.configure(presenter)
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadConfigureViews)
        XCTAssertTrue(viewController.loadAddSubviews)
        XCTAssertTrue(viewController.loadMakeConstraints)
    }
    
    func testPresenterLoadUpdateProfileDetails() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(profile: Profile(username: "test", name: "test", loginName: "test", bio: "test"))
        viewController.configure(presenter)
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadUpdateProfileDetails)
    }
    
    func testViewControllerCallLogoutAction() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        //when
        viewController.logoutAction()
        
        //then
        XCTAssertTrue(presenter.callLogoutAction)
    }
}
