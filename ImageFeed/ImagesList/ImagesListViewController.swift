import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    lazy private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { _ in
            self.updateTableViewAnimated()
        }
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            let indexPatch = sender as? IndexPath
            guard let viewController = viewController else { return }
            guard let indexPatch = indexPatch else { return }
            let image = UIImage(named: photosName[indexPatch.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private func

    private func updateTableViewAnimated() {
        let oldCount = self.photos.count
        let newCount = ImagesListService.shared.photos.count
        self.photos = ImagesListService.shared.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - Extensions

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photos = ImagesListService.shared.photos

        if let url = URL(string: photos[indexPath.row].thumbImageURL) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "stub")) { [weak self] result in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        if let date = photos[indexPath.row].created {
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        let isLaked = indexPath.row % 2 == 0
        let likeImage = isLaked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ImagesListService.shared.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return 0
//        }
        let thumbImageSize = photos[indexPath.row].thumbSize
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = thumbImageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = thumbImageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("\(indexPath.row)") // DEL
        
        if indexPath.row + 1 == ImagesListService.shared.photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}
