import UIKit

final class SplashViewController: UIViewController {
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            print("Токен найден, нужно обработать дальнейшую логику работы приложения")
        } else {
            print("Токен не найден. Нужно перенаправить пользователя на экран авторизации")
            performSegue(withIdentifier: "showAuthenticationScreen", sender: nil)
        }
    }
}
