@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testUpdateAvatar() {
        // Given
        let viewController = ProfileViewControllerSpy()
        
        // When
        viewController.updateAvatar()
        
        // Than
        XCTAssertTrue(viewController.didUpdateAvatar)
    }
}
