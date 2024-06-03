import Foundation
import ImageFeed

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
