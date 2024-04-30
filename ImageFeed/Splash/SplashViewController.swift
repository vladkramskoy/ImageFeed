import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private lazy var logoImageView = {
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView()
        logoImageView.image = logoImage
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
        setupUIElements(view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if KeychainWrapper.standard.string(forKey: "Auth token") != nil {
            guard let token = KeychainWrapper.standard.string(forKey: "Auth token") else {
                print("Error SplashViewController [KeychainWrapper.standard.string]: Failed to get value from Keychain")
                return
            }
            fetchProfile(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController,
                  let authViewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \("NavigationController")")
                return
            }
            authViewController.delegate = self
            navigationController.modalPresentationStyle = .fullScreen
            authViewController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
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
    
    private func setupUIElements(_ view: UIView) {
        view.addSubview(logoImageView)
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token: String = KeychainWrapper.standard.string(forKey: "Auth token") else {
            print("Error SplashViewController [KeychainWrapper.standard.string]: Failed to get value from Keychain")
            return
        }
        
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                guard let username = ProfileService.shared.profile?.username else { return }
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
                
                ProfileImageService.shared.fetchProfileImageURL(username: username) { result in
                    switch result {
                    case .success(_): break
                    case .failure(let error):
                        print("Error \(error)")
                    }
                }
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Error \(error)")
            }
        }
    }
}
