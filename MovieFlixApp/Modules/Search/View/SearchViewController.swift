//
//  SearchViewController.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 15/05/25.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func showError(message: String)
    func showLoading(_ isLoading: Bool)
}

class SearchViewController: UIViewController {
    
    var presenter: SearchPresenterProtocol!
    
    private let logoImageView = UIImageView()
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    private let allMoviesButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Search Film"
        
        logoImageView.image = UIImage(systemName: "film")
        logoImageView.tintColor = .systemBlue
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.placeholder = "Enter the name of the movie"
        searchTextField.borderStyle = .roundedRect
        searchTextField.autocorrectionType = .no
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = 8
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        allMoviesButton.setTitle("See All Movies", for: .normal)
        allMoviesButton.backgroundColor = .systemGreen
        allMoviesButton.setTitleColor(.white, for: .normal)
        allMoviesButton.layer.cornerRadius = 8
        allMoviesButton.addTarget(self, action: #selector(didTapAllMovies), for: .touchUpInside)
        allMoviesButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(allMoviesButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 120),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            
            allMoviesButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 24),
            allMoviesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            allMoviesButton.widthAnchor.constraint(equalToConstant: 200),
            allMoviesButton.heightAnchor.constraint(equalToConstant: 44),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: allMoviesButton.bottomAnchor, constant: 24)
        ])
    }
    
    @objc private func didTapSearch() {
        guard let query = searchTextField.text, !query.isEmpty else {
            showError(message: "Enter a valid name.")
            return
        }
        
        searchTextField.resignFirstResponder()
        presenter.searchMovie(query: query)
    }
    
    @objc private func didTapAllMovies() {
        presenter.showAllMovies()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapSearch()
        return true
    }
}

extension SearchViewController: SearchViewProtocol {
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            searchButton.isEnabled = false
            allMoviesButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            searchButton.isEnabled = true
            allMoviesButton.isEnabled = true
        }
    }
}
