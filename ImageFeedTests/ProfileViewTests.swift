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
    
    func testUpdateProfileDetails() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let testUser = "test"
        let testProfile = Profile(username: testUser, firstName: testUser, lastName: testUser, loginName: testUser, bio: testUser)
        
        // When
        viewController.updateProfileDetails(profile: testProfile)
        
        // Than
        XCTAssertTrue(viewController.didUpdateProfileDetails)
        XCTAssertEqual(viewController.nameLabel.text, testProfile.name)
        XCTAssertEqual(viewController.loginNameLabel.text, testProfile.loginName)
        XCTAssertEqual(viewController.descriptionLabel.text, testProfile.bio)
    }
}
