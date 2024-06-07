import XCTest
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var didAddImageListObserver = false
    var didUpdateTableViewAnimated = false
    
    func addImageListObserver() {
        didAddImageListObserver = true
    }
    
    func updateTableViewAnimated() {
        didUpdateTableViewAnimated = true
    }
}
