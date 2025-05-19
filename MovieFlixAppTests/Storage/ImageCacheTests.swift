//
//  ImageCacheTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class ImageCacheTests: XCTestCase {
    
    var imageCache: ImageCache!
    
    override func setUp() {
        super.setUp()
        imageCache = ImageCache.shared
        imageCache.clearCache()
    }
    
    override func tearDown() {
        imageCache.clearCache()
        super.tearDown()
    }
    
    func testGetImageFromCache() {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let testURLString = "https://test.com/image.jpg"
        imageCache.clearCache()
        
        imageCache.setImageInCache(testImage, for: testURLString)
        
        let cachedImage = imageCache.getImageFromCache(urlString: testURLString)
        
        XCTAssertNotNil(cachedImage)
        
        if let cachedImage = cachedImage {
            let cachedImageData = cachedImage.pngData()
            let originalImageData = testImage.pngData()
            XCTAssertEqual(cachedImageData, originalImageData)
        }
    }
    
    func testCancelImageLoad() {
        let testURLString = "https://test.com/image.jpg"
        
        let task = imageCache.loadImage(from: testURLString) { _ in }
        
        if task != nil {
            imageCache.cancelImageLoad(for: testURLString)
        }
        
        XCTAssertTrue(true, "Cancel operation completed without crashing")
    }
    
    func testClearCache() {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        let testImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let testURLString = "https://test.com/image.jpg"
        
        imageCache.setImageInCache(testImage, for: testURLString)
        
        XCTAssertNotNil(imageCache.getImageFromCache(urlString: testURLString))
        
        imageCache.clearCache()
        
        XCTAssertNil(imageCache.getImageFromCache(urlString: testURLString))
    }
}

// Mock URLSessionDataTask for testing
class ImageCacheMockURLSessionDataTask: URLSessionDataTask {
    var resumeCallCount = 0
    var cancelCallCount = 0
    private let closure: (() -> Void)?
    
    init(closure: (() -> Void)? = nil) {
        self.closure = closure
        super.init()
    }
    
    override func resume() {
        resumeCallCount += 1
        closure?()
    }
    
    override func cancel() {
        cancelCallCount += 1
    }
}

// Mock URLProtocol for intercepting network requests in tests
class ImageCacheMockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = ImageCacheMockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
