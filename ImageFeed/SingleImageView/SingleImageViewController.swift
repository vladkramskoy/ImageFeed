import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet { // Предусматривем ситуацию, если нужно будет подменить изображение в уже показанном контроллере извне
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
}
