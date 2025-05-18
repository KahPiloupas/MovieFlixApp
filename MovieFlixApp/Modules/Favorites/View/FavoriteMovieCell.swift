//
//  FavoriteMovieCell.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import UIKit

class FavoriteMovieCell: UITableViewCell {
    
    static let identifier = "FavoriteMovieCell"
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreTitleLabel = UILabel()
    private let genreValueLabel = UILabel()
    private let releaseTitleLabel = UILabel()
    private let releaseValueLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    private var imageTask: URLSessionDataTask?
    private var imageUrlString: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupLayout() {
        selectionStyle = .none
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .lightGray
        posterImageView.layer.cornerRadius = 6
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genreTitleLabel.text = "Gênero:"
        genreTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        genreTitleLabel.textColor = .black
        genreTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genreValueLabel.font = UIFont.systemFont(ofSize: 14)
        genreValueLabel.textColor = .darkGray
        genreValueLabel.numberOfLines = 0
        genreValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        releaseTitleLabel.text = "Data de lançamento:"
        releaseTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        releaseTitleLabel.textColor = .black
        releaseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        releaseValueLabel.font = UIFont.systemFont(ofSize: 14)
        releaseValueLabel.textColor = .darkGray
        releaseValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.tintColor = .systemRed
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreTitleLabel)
        contentView.addSubview(genreValueLabel)
        contentView.addSubview(releaseTitleLabel)
        contentView.addSubview(releaseValueLabel)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 180),
            
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            
            genreTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            genreTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            genreTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            genreValueLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            genreValueLabel.topAnchor.constraint(equalTo: genreTitleLabel.bottomAnchor, constant: 4),
            genreValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            releaseTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            releaseTitleLabel.topAnchor.constraint(equalTo: genreValueLabel.bottomAnchor, constant: 12),
            releaseTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            releaseValueLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            releaseValueLabel.topAnchor.constraint(equalTo: releaseTitleLabel.bottomAnchor, constant: 4),
            releaseValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            releaseValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func favoriteButtonTapped() {
        if let action = favoriteAction {
            action()
        }
    }
    
    // MARK: - Configuration
    
    var favoriteAction: (() -> Void)?
    
    func configure(with movie: MovieDetail) {
        titleLabel.text = movie.title
        
        if !movie.genres.isEmpty {
            let genreNames = movie.genres.map { $0.name }.joined(separator: ", ")
            genreValueLabel.text = genreNames
        } else {
            genreValueLabel.text = "Não disponível"
        }
        
        releaseValueLabel.text = formatDate(movie.releaseDate)
        
        if let posterPath = movie.backdropPath {
            loadImage(path: posterPath)
        } else {
            setPlaceholderImage()
        }
    }
    
    private func loadImage(path: String) {
        let baseURL = "https://image.tmdb.org/t/p/w200"
        let fullURL = baseURL + path
        
        if imageUrlString == fullURL { return }
        
        cancelImageLoading()
        
        imageUrlString = fullURL
        
        if posterImageView.image == nil {
            posterImageView.image = UIImage(systemName: "photo")
            posterImageView.tintColor = .darkGray
            posterImageView.contentMode = .center
        }
        
        imageTask = ImageCache.shared.loadImage(from: fullURL) { [weak self] image in
            guard let self = self, self.imageUrlString == fullURL else { return }
            
            if let image = image {
                self.posterImageView.image = image
                self.posterImageView.contentMode = .scaleAspectFill
                self.posterImageView.tintColor = nil
            } else {
                self.setPlaceholderImage()
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
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if inputFormatter.date(from: dateString) != nil {
            return "\(dateString.prefix(4))-\(dateString.prefix(7).suffix(2))-\(dateString.suffix(2))"
        }
        return dateString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        genreValueLabel.text = nil
        releaseValueLabel.text = nil
        favoriteAction = nil
        
        cancelImageLoading()
    }
}
