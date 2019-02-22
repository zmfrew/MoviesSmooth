import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let movieServiceClient = MovieServiceClient()
    private let backgroundQueue = DispatchQueue(label: "image downloader", qos: DispatchQoS.userInitiated)
    
    override func awakeFromNib() {
        movieImageView.addSubview(activityIndicator)
    }
    
    var movie: Movie? {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.rating)"
        descriptionLabel.text = movie.description
        
        UIView.animate(withDuration: 0.3, animations: {
            self.movieImageView.alpha = 1.0
            self.activityIndicator.alpha = 0
        }, completion: { _ in
            self.activityIndicator.stopAnimating()
        })
        
        
        backgroundQueue.async {
            self.movieServiceClient.getImageFor(movie: movie) { image in
                DispatchQueue.main.async {
                    self.movieImageView.image = image ?? UIImage(named: "red_chief")!
                }
            }
        }
    }
    
}
