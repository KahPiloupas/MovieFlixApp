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
    
    func fetchNowPlayingMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=pt-BR&page=\(page)"
        
        fetchMoviesByCategory(urlString: urlString, categoryName: "Now Playing", completion: completion)
    }
    
    func fetchTopRatedMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/top_rated?api_key=\(apiKey)&language=pt-BR&page=\(page)"
        
        fetchMoviesByCategory(urlString: urlString, categoryName: "Top Rated", completion: completion)
    }
    
    func fetchUpcomingMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=pt-BR&page=\(page)"
        
        fetchMoviesByCategory(urlString: urlString, categoryName: "Upcoming", completion: completion)
    }
    
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
    
    enum MovieAPIError: Error, LocalizedError {
        case invalidURL
        case noData
        case apiError(message: String)
        case unauthorized
        case httpError(statusCode: Int)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No received data"
            case .apiError(let message):
                return message
            case .unauthorized:
                return "Invalid or unauthorized API key"
            case .httpError(let statusCode):
                return "Request error: \(statusCode)"
            }
        }
    }
}
