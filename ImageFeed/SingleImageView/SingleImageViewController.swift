import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet { // Предусматривем ситуацию, если нужно будет подменить изображение в уже показанном контроллере извне
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    var fullImageURL: URL?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        
        downloadFullImage()
        
        scrollView.minimumZoomScale = 0.1 // 10%
        scrollView.maximumZoomScale = 1.25 // 125%
    }
    
    private func downloadFullImage() {
        UIBlockingProgressHUD.show()
        
        self.imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                showError()
            }
        }
    }
    
    private func showError() {
        let alertController = UIAlertController(title: "Ошибка!", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        let hideAction = UIAlertAction(title: "Не надо", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.downloadFullImage()
        }
        
        alertController.addAction(hideAction)
        alertController.addAction(repeatAction)
        present(alertController, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapSharingButton(_ sender: UIButton) {
        let share = UIActivityViewController(activityItems: [image ?? UIImage()], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

