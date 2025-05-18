//
//  MovieAPIService.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

class MovieAPIService {
    
    // MARK: API key from TMDB
    private let apiKey = "19a08dbbbeec24a0fec21f1b53249621"
    private let baseURL = "https://api.themoviedb.org/3"
    
    // MARK: - Search for films
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(queryEncoded)&language=pt-BR"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        DispatchQueue.global(qos: .background).async {
            let task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        if httpResponse.statusCode == 401 {
                            completion(.failure(MovieAPIError.unauthorized))
                            return
                        } else if httpResponse.statusCode >= 400 {
                            completion(.failure(MovieAPIError.httpError(statusCode: httpResponse.statusCode)))
                            return
                        }
                    }
                    
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
                        if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let statusMessage = errorResponse["status_message"] as? String {
                            completion(.failure(MovieAPIError.apiError(message: statusMessage)))
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Movie Details
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)&language=pt-BR"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.unauthorized))
                        }
                        return
                    } else if httpResponse.statusCode >= 400 {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.httpError(statusCode: httpResponse.statusCode)))
                        }
                        return
                    }
                }
                
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
                    if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let statusMessage = errorResponse["status_message"] as? String {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.apiError(message: statusMessage)))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - Search for Popular Films
    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=pt-BR&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.unauthorized))
                        }
                        return
                    } else if httpResponse.statusCode >= 400 {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.httpError(statusCode: httpResponse.statusCode)))
                        }
                        return
                    }
                }
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(MovieAPIError.noData))
                    }
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response.results))
                    }
                } catch {
                    if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let statusMessage = errorResponse["status_message"] as? String {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.apiError(message: statusMessage)))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Search for films Now Playing
    func fetchNowPlayingMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=pt-BR&page=\(page)"
        
        fetchMoviesByCategory(urlString: urlString, categoryName: "Now Playing", completion: completion)
    }
    
    // MARK: - Search for films Top Rated
    
    func fetchTopRatedMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/top_rated?api_key=\(apiKey)&language=pt-BR&page=\(page)"
        
        fetchMoviesByCategory(urlString: urlString, categoryName: "Top Rated", completion: completion)
    }
    
    // MARK: - Search for Upcoming films
    
    func fetchUpcomingMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=pt-BR&page=\(page)"
        
        fetchMoviesByCategory(urlString: urlString, categoryName: "Upcoming", completion: completion)
    }
    
    // MARK: - Método utilitário para busca de categorias
    
    private func fetchMoviesByCategory(urlString: String, categoryName: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.unauthorized))
                        }
                        return
                    } else if httpResponse.statusCode >= 400 {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.httpError(statusCode: httpResponse.statusCode)))
                        }
                        return
                    }
                }
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(MovieAPIError.noData))
                    }
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response.results))
                    }
                } catch {
                    if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let statusMessage = errorResponse["status_message"] as? String {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.apiError(message: statusMessage)))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Search for all films
    func fetchAllMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/discover/movie?api_key=\(apiKey)&language=pt-BR&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.unauthorized))
                        }
                        return
                    } else if httpResponse.statusCode >= 400 {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.httpError(statusCode: httpResponse.statusCode)))
                        }
                        return
                    }
                }
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(MovieAPIError.noData))
                    }
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response.results))
                    }
                } catch {
                    if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let statusMessage = errorResponse["status_message"] as? String {
                        DispatchQueue.main.async {
                            completion(.failure(MovieAPIError.apiError(message: statusMessage)))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Search for movies from all categories combined
    func fetchMoviesFromAllCategories(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        var allMovies: [Movie] = []
        let group = DispatchGroup()
        var anyError: Error?
        
        group.enter()
        fetchNowPlayingMovies(page: page) { result in
            switch result {
            case .success(let movies):
                allMovies.append(contentsOf: movies)
            case .failure(let error):
                anyError = error
            }
            group.leave()
        }
        
        group.enter()
        fetchPopularMovies(page: page) { result in
            switch result {
            case .success(let movies):
                allMovies.append(contentsOf: movies)
            case .failure(let error):
                if anyError == nil {
                    anyError = error
                }
            }
            group.leave()
        }
        
        group.enter()
        fetchTopRatedMovies(page: page) { result in
            switch result {
            case .success(let movies):
                allMovies.append(contentsOf: movies)
            case .failure(let error):
                if anyError == nil {
                    anyError = error
                }
            }
            group.leave()
        }
        
        group.enter()
        fetchUpcomingMovies(page: page) { result in
            switch result {
            case .success(let movies):
                allMovies.append(contentsOf: movies)
            case .failure(let error):
                if anyError == nil {
                    anyError = error
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = anyError, allMovies.isEmpty {
                completion(.failure(error))
            } else {
                let uniqueMovies = Array(Dictionary(grouping: allMovies) { $0.id }.values.map { $0.first! })
                completion(.success(uniqueMovies))
            }
        }
    }
    
    // MARK: - API Errors
    enum MovieAPIError: Error, LocalizedError {
        case invalidURL
        case noData
        case apiError(message: String)
        case unauthorized
        case httpError(statusCode: Int)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "URL inválida"
            case .noData:
                return "Nenhum dado recebido"
            case .apiError(let message):
                return message
            case .unauthorized:
                return "Chave de API inválida ou não autorizada"
            case .httpError(let statusCode):
                return "Erro na requisição: \(statusCode)"
            }
        }
    }
}
