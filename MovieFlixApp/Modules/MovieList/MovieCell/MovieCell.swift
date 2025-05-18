//
//  MovieCell.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"
    
    private let movieImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let favoriteIndicator = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.backgroundColor = .lightGray
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.layer.cornerRadius = 4
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.textColor = .darkGray
        
        favoriteIndicator.image = UIImage(systemName: "star.fill")
        favoriteIndicator.tintColor = .systemYellow
        favoriteIndicator.isHidden = true
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, ratingLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(movieImageView)
        contentView.addSubview(textStack)
        contentView.addSubview(favoriteIndicator)
        
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 60),
            movieImageView.heightAnchor.constraint(equalToConstant: 90),
            movieImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            movieImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            textStack.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(equalTo: favoriteIndicator.leadingAnchor, constant: -12),
            textStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            favoriteIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            favoriteIndicator.widthAnchor.constraint(equalToConstant: 20),
            favoriteIndicator.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.originalTitle
        
        if movie.voteAverage > 0 {
            ratingLabel.text = "⭐️ \(movie.voteAverage)"
        } else {
            ratingLabel.text = "No review."
        }
        
        if let posterPath = movie.posterPath {
            loadImage(path: posterPath)
        } else {
            movieImageView.image = UIImage(systemName: "film")
            movieImageView.tintColor = .darkGray
        }
        
        favoriteIndicator.isHidden = !FavoritesManager.shared.isFavorite(id: movie.id)
    }
    
    private var imageTask: URLSessionDataTask?
    private var imageUrlString: String?
    
    private func loadImage(path: String) {
        let baseURL = "https://image.tmdb.org/t/p/w200"
        let fullURL = baseURL + path
        
        if imageUrlString == fullURL { return }
        
        cancelImageLoading()
        
        imageUrlString = fullURL
        
        if movieImageView.image == nil {
            movieImageView.image = UIImage(systemName: "photo")
            movieImageView.tintColor = .darkGray
            movieImageView.contentMode = .center
        }
        
        imageTask = ImageCache.shared.loadImage(from: fullURL) { [weak self] image in
            guard let self = self, self.imageUrlString == fullURL else { return }
            
            if let image = image {
                self.movieImageView.image = image
                self.movieImageView.contentMode = .scaleAspectFill
                self.movieImageView.tintColor = nil
            } else {
                self.setPlaceholderImage()
            }
        }
    }
    
    private func setPlaceholderImage() {
        movieImageView.image = UIImage(systemName: "film")
        movieImageView.tintColor = .darkGray
        movieImageView.contentMode = .center
    }
    
    private func cancelImageLoading() {
        if let urlString = imageUrlString {
            ImageCache.shared.cancelImageLoad(for: urlString)
        }
        imageTask = nil
        imageUrlString = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        ratingLabel.text = nil
        favoriteIndicator.isHidden = true
        
        cancelImageLoading()
    }
}
