//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Anton Reynikov on 10.04.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    private let constants = Constants()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(constants.login)
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(constants.password)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let buttonLike = cellToLike.buttons["like button"]
       
        sleep(2)

        buttonLike.tap()

        sleep(2)

        XCTAssertTrue(cellToLike.buttons["Active"].exists)

        buttonLike.tap()

        sleep(2)

        XCTAssertTrue(cellToLike.buttons["No Active"].exists)

        cellToLike.swipeUp()

        sleep(2)

        let cellToSingleImage = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        sleep(2)

        cellToSingleImage.tap()

        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav back button"]
        navBackButtonWhiteButton.tap()

        sleep(2)

        XCTAssertTrue(cellToSingleImage.exists)
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts[constants.name].exists)
        XCTAssertTrue(app.staticTexts[constants.loginName].exists)

        app.buttons["logout button"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 2))
    }
}
