//
//  MovieDetailViewController.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func displayMovieDetail(_ detail: MovieDetail)
    func displayError(_ message: String)
}

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
    // MARK: - Properties
    var presenter: MovieDetailPresenterProtocol!
    private var currentMovie: MovieDetail?
    
    private var posterImageTask: URLSessionDataTask?
    private var backdropImageTask: URLSessionDataTask?
    private var posterUrlString: String?
    private var backdropUrlString: String?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backdropImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let ratingContainerView = UIView()
    private let ratingCircleView = UIView()
    private let ratingLabel = UILabel()
    
    private let infoContainerView = UIView()
    private let budgetTitleLabel = UILabel()
    private let budgetValueLabel = UILabel()
    private let releaseTitleLabel = UILabel()
    private let releaseValueLabel = UILabel()
    private let revenueTitleLabel = UILabel()
    private let revenueValueLabel = UILabel()
    private let genresTitleLabel = UILabel()
    private let genresValueLabel = UILabel()
    
    private let plotLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItems()
        presenter.viewDidLoad()
    }
    
    deinit {
        cancelImageLoadingTasks()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Detalhes do Filme"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        setupHeaderView()
        setupRatingView()
        setupInfoView()
        setupPlotView()
    }
    
    private func setupNavigationItems() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "heart.fill"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
        favoriteButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItems = [favoriteButton]
    }
    
    private func setupHeaderView() {
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        backdropImageView.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .lightGray
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.borderColor = UIColor.white.cgColor
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(backdropImageView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 220),
            
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 40),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 48),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    private func setupRatingView() {
        ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingCircleView.backgroundColor = .white
        ratingCircleView.layer.cornerRadius = 20
        ratingCircleView.layer.borderWidth = 3
        ratingCircleView.layer.borderColor = UIColor.darkGray.cgColor
        ratingCircleView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingLabel.font = .boldSystemFont(ofSize: 16)
        ratingLabel.textAlignment = .center
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(ratingContainerView)
        ratingContainerView.addSubview(ratingCircleView)
        ratingCircleView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            ratingContainerView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            ratingContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            ratingContainerView.widthAnchor.constraint(equalToConstant: 40),
            ratingContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            ratingCircleView.topAnchor.constraint(equalTo: ratingContainerView.topAnchor),
            ratingCircleView.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor),
            ratingCircleView.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor),
            ratingCircleView.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor),
            
            ratingLabel.centerXAnchor.constraint(equalTo: ratingCircleView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingCircleView.centerYAnchor),
        ])
    }
    
    private func setupInfoView() {
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        infoContainerView.backgroundColor = .white
        infoContainerView.layer.cornerRadius = 8
        infoContainerView.layer.shadowColor = UIColor.black.cgColor
        infoContainerView.layer.shadowOpacity = 0.1
        infoContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        infoContainerView.layer.shadowRadius = 4
        
        budgetTitleLabel.text = "Custo de Produção:"
        budgetTitleLabel.font = .boldSystemFont(ofSize: 16)
        budgetTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        budgetValueLabel.text = "Carregando..."
        budgetValueLabel.font = .systemFont(ofSize: 16)
        budgetValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        releaseTitleLabel.text = "Data de lançamento:"
        releaseTitleLabel.font = .boldSystemFont(ofSize: 16)
        releaseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        releaseValueLabel.text = "Carregando..."
        releaseValueLabel.font = .systemFont(ofSize: 16)
        releaseValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        revenueTitleLabel.text = "Valor arrecadado:"
        revenueTitleLabel.font = .boldSystemFont(ofSize: 16)
        revenueTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        revenueValueLabel.text = "Carregando..."
        revenueValueLabel.font = .systemFont(ofSize: 16)
        revenueValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genresTitleLabel.text = "Gêneros:"
        genresTitleLabel.font = .boldSystemFont(ofSize: 16)
        genresTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genresValueLabel.text = "Carregando..."
        genresValueLabel.font = .systemFont(ofSize: 16)
        genresValueLabel.numberOfLines = 0
        genresValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoContainerView.addSubview(budgetTitleLabel)
        infoContainerView.addSubview(budgetValueLabel)
        infoContainerView.addSubview(releaseTitleLabel)
        infoContainerView.addSubview(releaseValueLabel)
        infoContainerView.addSubview(revenueTitleLabel)
        infoContainerView.addSubview(revenueValueLabel)
        infoContainerView.addSubview(genresTitleLabel)
        infoContainerView.addSubview(genresValueLabel)
        contentView.addSubview(infoContainerView)
        
        NSLayoutConstraint.activate([
            infoContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            infoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            budgetTitleLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 12),
            budgetTitleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            budgetTitleLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            budgetValueLabel.topAnchor.constraint(equalTo: budgetTitleLabel.bottomAnchor, constant: 4),
            budgetValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            budgetValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            releaseTitleLabel.topAnchor.constraint(equalTo: budgetValueLabel.bottomAnchor, constant: 12),
            releaseTitleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            releaseTitleLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            releaseValueLabel.topAnchor.constraint(equalTo: releaseTitleLabel.bottomAnchor, constant: 4),
            releaseValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            releaseValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            revenueTitleLabel.topAnchor.constraint(equalTo: releaseValueLabel.bottomAnchor, constant: 12),
            revenueTitleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            revenueTitleLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            revenueValueLabel.topAnchor.constraint(equalTo: revenueTitleLabel.bottomAnchor, constant: 4),
            revenueValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            revenueValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            genresTitleLabel.topAnchor.constraint(equalTo: revenueValueLabel.bottomAnchor, constant: 12),
            genresTitleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            genresTitleLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            genresValueLabel.topAnchor.constraint(equalTo: genresTitleLabel.bottomAnchor, constant: 4),
            genresValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            genresValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            genresValueLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupPlotView() {
        plotLabel.numberOfLines = 0
        plotLabel.font = .systemFont(ofSize: 16)
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(plotLabel)
        
        NSLayoutConstraint.activate([
            plotLabel.topAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: 24),
            plotLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            plotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            plotLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func toggleFavorite() {
        guard let movie = currentMovie else { return }
        presenter.toggleFavorite(movie)
        
        let isFavorite = FavoritesManager.shared.isFavorite(id: movie.id)
        if let favoriteButton = navigationItem.rightBarButtonItems?[0] {
            favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
        }
    }
    
    @objc private func showMoreOptions() {}
    
    // MARK: - Helper Methods
    
    private func loadPosterImage(path: String?) {
        guard let path = path else {
            posterImageView.image = UIImage(systemName: "film")
            posterImageView.tintColor = .darkGray
            posterImageView.contentMode = .center
            return
        }
        
        let baseURL = "https://image.tmdb.org/t/p/w342"
        let fullURL = baseURL + path
        
        if let cachedImage = ImageCache.shared.getImageFromCache(urlString: fullURL) {
            posterImageView.image = cachedImage
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.tintColor = nil
            posterUrlString = fullURL
            return
        }
        
        if posterUrlString == fullURL { return }
        
        if let urlString = posterUrlString {
            ImageCache.shared.cancelImageLoad(for: urlString)
        }
        posterImageTask = nil
        
        posterUrlString = fullURL
        
        if posterImageView.image == nil {
            posterImageView.image = UIImage(systemName: "photo")
            posterImageView.tintColor = .darkGray
            posterImageView.contentMode = .center
        }
        
        posterImageTask = ImageCache.shared.loadImage(from: fullURL) { [weak self] image in
            guard let self = self, self.posterUrlString == fullURL else { return }
            
            if let image = image {
                UIView.transition(with: self.posterImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.posterImageView.image = image
                    self.posterImageView.contentMode = .scaleAspectFill
                    self.posterImageView.tintColor = nil
                })
            } else {
                self.posterImageView.image = UIImage(systemName: "film")
                self.posterImageView.tintColor = .darkGray
                self.posterImageView.contentMode = .center
            }
        }
    }
    
    private func loadBackdropImage(path: String?) {
        guard let path = path else {
            backdropImageView.image = UIImage(systemName: "film")
            backdropImageView.tintColor = .darkGray
            backdropImageView.contentMode = .center
            return
        }
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullURL = baseURL + path
        
        if let cachedImage = ImageCache.shared.getImageFromCache(urlString: fullURL) {
            backdropImageView.image = cachedImage
            backdropImageView.contentMode = .scaleAspectFill
            backdropImageView.tintColor = nil
            backdropUrlString = fullURL
            return
        }
        
        if backdropUrlString == fullURL { return }
        
        if let urlString = backdropUrlString {
            ImageCache.shared.cancelImageLoad(for: urlString)
        }
        backdropImageTask = nil
        
        backdropUrlString = fullURL
        
        if backdropImageView.image == nil {
            backdropImageView.image = UIImage(systemName: "photo")
            backdropImageView.tintColor = .darkGray
            backdropImageView.contentMode = .center
        }
        
        backdropImageTask = ImageCache.shared.loadImage(from: fullURL) { [weak self] image in
            guard let self = self, self.backdropUrlString == fullURL else { return }
            
            if let image = image {
                UIView.transition(with: self.backdropImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.backdropImageView.image = image
                    self.backdropImageView.contentMode = .scaleAspectFill
                    self.backdropImageView.tintColor = nil
                })
            } else {
                self.backdropImageView.image = UIImage(systemName: "film")
                self.backdropImageView.tintColor = .darkGray
                self.backdropImageView.contentMode = .center
            }
        }
    }
    
    private func cancelImageLoadingTasks() {
        if let urlString = posterUrlString {
            ImageCache.shared.cancelImageLoad(for: urlString)
        }
        
        if let urlString = backdropUrlString {
            ImageCache.shared.cancelImageLoad(for: urlString)
        }
        
        posterImageTask = nil
        backdropImageTask = nil
        posterUrlString = nil
        backdropUrlString = nil
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if inputFormatter.date(from: dateString) != nil {
            return dateString.prefix(4) + "-" + dateString.prefix(7).suffix(2) + "-" + dateString.suffix(2)
        }
        return dateString
    }
    
    private func formatCurrency(_ value: Int) -> String {
        guard value > 0 else { return "Não disponível" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
    
    // MARK: - MovieDetailViewProtocol
    
    func displayMovieDetail(_ detail: MovieDetail) {
        currentMovie = detail
        
        titleLabel.text = detail.title
        releaseValueLabel.text = formatDate(detail.releaseDate)
        ratingLabel.text = String(format: "%.1f", detail.voteAverage)
        budgetValueLabel.text = formatCurrency(detail.budget)
        revenueValueLabel.text = formatCurrency(detail.revenue)
        plotLabel.text = detail.overview
        
        if !detail.genres.isEmpty {
            let genreNames = detail.genres.map { $0.name }.joined(separator: ", ")
            genresValueLabel.text = genreNames
        } else {
            genresValueLabel.text = "Não disponível"
        }
        
        let isFavorite = FavoritesManager.shared.isFavorite(id: detail.id)
        if let favoriteButton = navigationItem.rightBarButtonItems?[0] {
            favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
        }
        
        loadBackdropImage(path: detail.backdropPath)
        loadPosterImage(path: detail.backdropPath)
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
