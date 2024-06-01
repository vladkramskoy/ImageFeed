@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        // Given
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.presenter?.viewDidLoad()
        
        // Then
        XCTAssertTrue(viewController.loadRequest)
    }
}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    var request: URLRequest? = nil
    

    
    func viewDidLoad() {
        viewDidLoadCalled = true
        
        let url = URL(string: "https://example.com")
        request = URLRequest(url: url!)
        view?.load(request: request!)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadRequest: Bool = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequest = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
