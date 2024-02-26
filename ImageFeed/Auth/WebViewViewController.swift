import UIKit
import WebKit

class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    
    enum WebViewConstants {
        static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    override func viewDidLoad() {
        loadAuthView()
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.UnsplashAuthorizeURLString) else {
            print("Ошибка при создании URLComponents")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("Ошибка: urlComponents равен nil")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
