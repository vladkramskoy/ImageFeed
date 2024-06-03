import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var didUpdateAvatar = false
    var didUpdateProfileDetails = false
    
    func updateAvatar() {
        didUpdateAvatar = true
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        didUpdateAvatar = true
    }
}
