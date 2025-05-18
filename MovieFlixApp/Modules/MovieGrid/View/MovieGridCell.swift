//
//  MovieGridCell.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import UIKit

class MovieGridCell: UICollectionViewCell {
    
    static let identifier = "MovieGridCell"
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingView = UIView()
    private let ratingLabel = UILabel()
    private let favoriteIndicator = UIImageView()
    
    private var imageTask: URLSessionDataTask?
    private var imageUrlString: String?
    private var currentMovieId: Int = 0
    
    var favoriteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.clipsToBounds = false
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .lightGray
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.textColor = .darkText
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ratingView.backgroundColor = .systemYellow
        ratingView.layer.cornerRadius = 4
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        ratingLabel.textColor = .white
        ratingLabel.textAlignment = .center
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteIndicator.image = UIImage(systemName: "star.fill")
        favoriteIndicator.tintColor = .systemYellow
        favoriteIndicator.isHidden = true
        favoriteIndicator.translatesAutoresizingMaskIntoConstraints = false
        favoriteIndicator.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteIconTapped))
        favoriteIndicator.addGestureRecognizer(tapGesture)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingView)
        ratingView.addSubview(ratingLabel)
        contentView.addSubview(favoriteIndicator)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ratingView.widthAnchor.constraint(equalToConstant: 36),
            ratingView.heightAnchor.constraint(equalToConstant: 16),
            ratingView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            ratingLabel.topAnchor.constraint(equalTo: ratingView.topAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: ratingView.bottomAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor),
            
            favoriteIndicator.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            favoriteIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteIndicator.widthAnchor.constraint(equalToConstant: 16),
            favoriteIndicator.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    @objc private func favoriteIconTapped() {
        favoriteAction?()
    }
    
    func configure(with movie: Movie) {
        currentMovieId = movie.id
        
        titleLabel.text = movie.originalTitle
        
        if movie.voteAverage > 0 {
            ratingLabel.text = "\(movie.voteAverage)"
            ratingView.isHidden = false
        } else {
            ratingView.isHidden = true
        }
        
        setPlaceholderImage()
        
        if let posterPath = movie.posterPath {
            loadImage(path: posterPath, for: movie.id)
        }
        
        favoriteIndicator.isHidden = !FavoritesManager.shared.isFavorite(id: movie.id)
    }
    
    private func loadImage(path: String, for movieId: Int) {
        let baseURL = "https://image.tmdb.org/t/p/w342"
        let fullURL = baseURL + path
        
        if imageUrlString == fullURL { return }
        
        cancelImageLoading()
        
        imageUrlString = fullURL
        
        if let cachedImage = ImageCache.shared.getImageFromCache(urlString: fullURL) {
            posterImageView.image = cachedImage
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.tintColor = nil
            return
        }
        
        imageTask = ImageCache.shared.loadImage(from: fullURL) { [weak self] image in
            guard let self = self, 
                  self.currentMovieId == movieId,
                  self.imageUrlString == fullURL else { 
                return 
            }
            
            if let image = image {
                self.posterImageView.image = image
                self.posterImageView.contentMode = .scaleAspectFill
                self.posterImageView.tintColor = nil
            }
        }
    }
    
    private func setPlaceholderImage() {
        posterImageView.image = UIImage(systemName: "film")
        posterImageView.tintColor = .darkGray
        posterImageView.contentMode = .center
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
        favoriteAction = nil
        currentMovieId = 0
        
        posterImageView.image = nil
        posterImageView.backgroundColor = .lightGray
        
        cancelImageLoading()
    }
}
