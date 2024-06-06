import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    enum PersonalData {
        static let email = "email"
        static let password = "password"
        static let name = "full name"
        static let login = "@login"
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["WebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(PersonalData.email)
        webView.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).tap()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 6))
        passwordTextField.tap()
        passwordTextField.typeText(PersonalData.password)
        webView.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).tap()
        
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 5))
        webView.buttons["Login"].tap()
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).waitForExistence(timeout: 3))
        
        let tableQuery = app.tables
        let cell = tableQuery.descendants(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        cell.swipeDown()
        sleep(2)
        
        let cellTwo = tableQuery.descendants(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.buttons["LikeButton"].waitForExistence(timeout: 5))
        sleep(6)
        cellTwo.buttons["LikeButton"].tap()
        sleep(3)
        cellTwo.buttons["LikeButton"].tap()
        sleep(3)
        
        cellTwo.tap()
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        XCTAssertTrue(app.buttons["BackButton"].waitForExistence(timeout: 3))
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).waitForExistence(timeout: 3))
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 1).waitForExistence(timeout: 3))
        
        XCTAssertTrue(app.staticTexts[PersonalData.name].exists)
        XCTAssertTrue(app.staticTexts[PersonalData.login].exists)
        XCTAssertTrue(app.buttons["LogoutButton"].waitForExistence(timeout: 3))
        
        sleep(3)
        app.buttons["LogoutButton"].tap()
        
        sleep(3)
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }
}
