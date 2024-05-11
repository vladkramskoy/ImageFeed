import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()
        
    // MARK: - Private Methods
    
    private func configGradientView() {
        
        gradientView.backgroundColor = UIColor.clear
        
        cellImage.addSubview(gradientView)

        gradientView.translatesAutoresizingMaskIntoConstraints = false

        gradientView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        gradientLayer.colors = [UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.0).cgColor, UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradientLayer.frame = gradientView.bounds
    }
    
    // MARK: - Override Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configGradientView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
}

extension ImagesListCell {
    func setIsLiked(cell: ImagesListCell, photo: Photo) {
        let isLiked = photo.isLiked
        let likeImage = isLiked ? UIImage(named: "like_button_off") : UIImage(named: "like_button_on")
        
        DispatchQueue.main.async {
            cell.likeButton.setImage(likeImage, for: .normal)
        }
    }
}

