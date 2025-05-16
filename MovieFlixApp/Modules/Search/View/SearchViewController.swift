//
//  SearchViewController.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 15/05/25.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func showError(message: String)
}

class SearchViewController: UIViewController {
    
    var presenter: SearchPresenterProtocol!
    
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Buscar Filme"
        
        searchTextField.placeholder = "Digite o nome do filme"
        searchTextField.borderStyle = .roundedRect
        
        searchButton.setTitle("Buscar", for: .normal)
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    @objc private func didTapSearch() {
        guard let query = searchTextField.text else { return }
        presenter.searchMovie(query: query)
    }
}

extension SearchViewController: SearchViewProtocol {
    func showError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
