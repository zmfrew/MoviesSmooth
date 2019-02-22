//
//  MovieDetailViewController.swift
//  MoviesSmooth
//
//  Created by FREW, ZACHARY [AG-Contractor/1000] on 2/22/19.
//  Copyright © 2019 Bayer. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    var movie: Movie?
    var movieImage: UIImage?
    
    private func updateView() {
        guard let movie = movie else { return }
        
        DispatchQueue.main.async {
            self.titleLabel.text = movie.title
            self.ratingLabel.text = "\(movie.rating)"
            self.descriptionTextView.text = movie.description
            self.movieImageView.image = self.movieImage ?? UIImage(named: "red_chief")!
        }
    }
}
