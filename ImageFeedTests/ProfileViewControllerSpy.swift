import UIKit.UILabel
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var didUpdateAvatar = false
    var didUpdateProfileDetails = false
    
    var nameLabel = UILabel()
    var loginNameLabel = UILabel()
    var descriptionLabel = UILabel()
    
    func updateAvatar() {
        didUpdateAvatar = true
    }
    
    func updateProfileDetails(profile: Profile) {
        didUpdateProfileDetails = true
        
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}
