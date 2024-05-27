import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progressViewStyle = .bar
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [], changeHandler: { [weak self] _, _ in // KVO
            guard let self = self else { return }
            self.updateProgress()
        })
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    private func updateProgress() { // Обновляем данные
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001 // Если разница между этими значениями меньше или равна 0.0001, то условие будет истинным и мы скроем индиктор
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
                
    }
}
