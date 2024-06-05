@testable import ImageFeed
import XCTest

final class ImageListViewControllerTests: XCTestCase {
    func testAddImageListObserver() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        
        // When
        viewController.addImageListObserver()
        
        // Then
        XCTAssertTrue(viewController.didAddImageListObserver)
    }
    
    func testUpdateTableViewAnimated() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        
        // When
        viewController.updateTableViewAnimated()
        
        // Then
        XCTAssertTrue(viewController.didUpdateTableViewAnimated)
    }
}
