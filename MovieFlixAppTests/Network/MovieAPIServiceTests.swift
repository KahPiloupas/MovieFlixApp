//
//  MovieAPIServiceTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

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

class MovieAPIServiceTests: XCTestCase {
    
    var apiService: MovieAPIService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        apiService = MockableMovieAPIService(session: mockURLSession)
    }
    
    override func tearDown() {
        apiService = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testSearchMoviesSuccess() {
        let moviesData = """
        {
            "results": [
                {
                    "id": 1,
                    "original_title": "Test Movie 1",
                    "poster_path": "/path1.jpg",
                    "vote_average": 7.5
                },
                {
                    "id": 2,
                    "original_title": "Test Movie 2",
                    "poster_path": "/path2.jpg",
                    "vote_average": 8.0
                }
            ],
            "page": 1,
            "total_pages": 10,
            "total_results": 100
        }
        """.data(using: .utf8)!
        
        let response = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession.nextData = moviesData
        mockURLSession.nextResponse = response
        mockURLSession.nextError = nil
        
        let expectation = self.expectation(description: "Search movies")
        
        apiService.searchMovies(query: "test") { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 2)
                XCTAssertEqual(movies[0].id, 1)
                XCTAssertEqual(movies[0].originalTitle, "Test Movie 1")
                XCTAssertEqual(movies[1].id, 2)
                XCTAssertEqual(movies[1].originalTitle, "Test Movie 2")
            case .failure(let error):
                XCTFail("Search failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSearchMoviesFailure() {
        let response = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        mockURLSession.nextData = nil
        mockURLSession.nextResponse = response
        mockURLSession.nextError = nil
        
        let expectation = self.expectation(description: "Search movies failure")
        
        apiService.searchMovies(query: "test") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, MovieAPIError.unauthorized.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchMovieDetailSuccess() {
        let movieDetailData = """
        {
            "id": 1,
            "original_title": "Test Movie",
            "title": "Test Movie",
            "overview": "This is a test movie",
            "release_date": "2023-01-01",
            "vote_average": 7.5,
            "backdrop_path": "/backdrop.jpg",
            "budget": 1000000,
            "revenue": 5000000,
            "genres": [
                {"id": 28, "name": "Action"}
            ]
        }
        """.data(using: .utf8)!
        
        let response = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession.nextData = movieDetailData
        mockURLSession.nextResponse = response
        mockURLSession.nextError = nil
        
        let expectation = self.expectation(description: "Fetch movie detail")
        
        apiService.fetchMovieDetail(id: 1) { result in
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.id, 1)
                XCTAssertEqual(detail.originalTitle, "Test Movie")
                XCTAssertEqual(detail.title, "Test Movie")
                XCTAssertEqual(detail.overview, "This is a test movie")
                XCTAssertEqual(detail.releaseDate, "2023-01-01")
                XCTAssertEqual(detail.voteAverage, 7.5)
                XCTAssertEqual(detail.backdropPath, "/backdrop.jpg")
                XCTAssertEqual(detail.budget, 1000000)
                XCTAssertEqual(detail.revenue, 5000000)
                XCTAssertEqual(detail.genres.count, 1)
                XCTAssertEqual(detail.genres[0].id, 28)
                XCTAssertEqual(detail.genres[0].name, "Action")
            case .failure(let error):
                XCTFail("Fetch detail failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchPopularMoviesSuccess() {
        let moviesData = """
        {
            "results": [
                {
                    "id": 1,
                    "original_title": "Popular Movie 1",
                    "poster_path": "/path1.jpg",
                    "vote_average": 7.5
                },
                {
                    "id": 2,
                    "original_title": "Popular Movie 2",
                    "poster_path": "/path2.jpg",
                    "vote_average": 8.0
                }
            ],
            "page": 1,
            "total_pages": 10,
            "total_results": 100
        }
        """.data(using: .utf8)!
        
        let response = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession.nextData = moviesData
        mockURLSession.nextResponse = response
        mockURLSession.nextError = nil
        
        let expectation = self.expectation(description: "Fetch popular movies")
        
        apiService.fetchPopularMovies(page: 1) { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 2)
                XCTAssertEqual(movies[0].id, 1)
                XCTAssertEqual(movies[0].originalTitle, "Popular Movie 1")
                XCTAssertEqual(movies[1].id, 2)
                XCTAssertEqual(movies[1].originalTitle, "Popular Movie 2")
            case .failure(let error):
                XCTFail("Fetch popular movies failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class MockableMovieAPIService: MovieAPIService {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
        super.init()
    }
    
    override func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(getBaseURL())/search/movie?api_key=\(getApiKey())&query=\(queryEncoded)&language=pt-BR"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: { (result: Result<MovieSearchResponse, Error>) in
                switch result {
                case .success(let searchResponse):
                    completion(.success(searchResponse.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
        task.resume()
    }
    
    override func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = "\(getBaseURL())/movie/\(id)?api_key=\(getApiKey())&language=pt-BR"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    override func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(getBaseURL())/movie/popular?api_key=\(getApiKey())&language=pt-BR&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.handleResponse(data: data, response: response, error: error, completion: { (result: Result<MovieSearchResponse, Error>) in
                switch result {
                case .success(let searchResponse):
                    completion(.success(searchResponse.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
        task.resume()
    }
    
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401 {
                completion(.failure(MovieAPIError.unauthorized))
                return
            } else if httpResponse.statusCode >= 400 {
                completion(.failure(MovieAPIError.httpError(statusCode: httpResponse.statusCode)))
                return
            }
        }
        
        guard let data = data else {
            completion(.failure(MovieAPIError.noData))
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decoded))
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

class MockURLSession: URLSession {
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MovieAPIMockURLSessionDataTask {
            completionHandler(self.nextData, self.nextResponse, self.nextError)
        }
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MovieAPIMockURLSessionDataTask {
            completionHandler(self.nextData, self.nextResponse, self.nextError)
        }
    }
}

class MovieAPIMockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }
    
    override func resume() {
        closure()
    }
}
