import UIKit

class ProfileViewController: UIViewController {
    static let avatarImageView = UIImageView()
    static let logoutButton = UIButton.systemButton(with: UIImage(named: "logout_button") ?? UIImage(), target: ProfileViewController.self, action: nil)
    static let nameLabel = UILabel()
    static let loginNameLabel = UILabel()
    static let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        ProfileViewController.setupView(view)
        ProfileViewController.setupAvatarImageView(view)
        ProfileViewController.setupLogoutButton(view)
        ProfileViewController.setupNameLabel(view)
        ProfileViewController.setupLoginNameLabel(view)
        ProfileViewController.setupDescriptionLabel(view)
    }
    
    static func setupView(_ view: UIView) {
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
    }
    
    static func setupAvatarImageView(_ view: UIView) {
        let photoImage = UIImage(named: "avatar")
        avatarImageView.image = photoImage
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    static func setupLogoutButton(_ view: UIView) {

        logoutButton.tintColor = UIColor(named: "YP Red (iOS)")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    static func setupNameLabel(_ view: UIView) {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = UIColor(named: "YP White (iOS)")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
    }
    
    static func setupLoginNameLabel(_ view: UIView) {
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.textColor = UIColor(named: "YP Gray (iOS)")
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        loginNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
    }
    
    static func setupDescriptionLabel(_ view: UIView) {
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = UIColor(named: "YP White (iOS)")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  16).isActive = true
    }
}
