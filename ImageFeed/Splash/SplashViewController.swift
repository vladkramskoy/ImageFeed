import UIKit

final class SplashViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage.shared.token != nil {
            guard let token = OAuth2TokenStorage.shared.token else { return }
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: "showAuthenticationScreen", sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarViewController")
            
            window.rootViewController = tabBarController
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAuthenticationScreen" {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let authViewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \("showAuthenticationScreen")")
                return
            }
            
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.switchToTabBarController()
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }
}
