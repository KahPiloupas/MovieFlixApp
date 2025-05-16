//
//  MovieAPIService.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

class MovieAPIService {
    
    private let apiKey = "19a08dbbbeec24a0fec21f1b53249621"
    private let baseURL = "https://api.themoviedb.org/3"
    
    // MARK: - Busca por filmes
    
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(queryEncoded)&language=pt-BR"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(MovieAPIError.noData))
                        return
                    }
                    
                    do {
                        let decoded = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                        completion(.success(decoded.results))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Detalhes do filme
    
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)&language=pt-BR"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(MovieAPIError.noData)) }
                    return
                }
                
                do {
                    let detail = try JSONDecoder().decode(MovieDetail.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(detail))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - Erros da API
    
    enum MovieAPIError: Error {
        case invalidURL
        case noData
    }
}
