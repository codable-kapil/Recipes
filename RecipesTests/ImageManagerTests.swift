//
//  ImageManagerTests.swift
//  RecipesTests
//
//  Created by Kapil Shivhare on 2/21/25.
//

import XCTest
import SwiftUI
@testable import Recipes

final class ImageManagerTests: XCTestCase {
    
    var imageManager: ImageManager!
    var mockImageCache: MockImageCache!
    var mockURLSession: MockURLSession!
    var fileManager: FileManager!
    var cacheDirectoryURL: URL!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockImageCache = MockImageCache()
        mockURLSession = MockURLSession()
        imageManager = ImageManager(urlSession: mockURLSession)
        
        fileManager = FileManager.default
        cacheDirectoryURL = (fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(path: "Fetch_Recipe_Images"))!
        try? fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        
        imageManager = nil
        mockImageCache = nil
        mockURLSession = nil
        
        try? fileManager.removeItem(at: cacheDirectoryURL)
        
        try super.tearDownWithError()
    }

    func testCacheImage() throws {
        // Arrange
        let url = "https://apple.com/img.png"
        let image = UIImage(systemName: "star")!
        
        // Act
        imageManager.cacheImage(image, for: url)
        
        // Assert
        let cachedImageURL = cacheDirectoryURL.appendingPathComponent(url.hashValue.description)
        XCTAssertTrue(fileManager.fileExists(atPath: cachedImageURL.path), "cached image should exist in the cache directry")
    }
    
    func testGetImageFromCache() async {
        // Arrange
        let url = "https://apple.com/img.png"
        let image = UIImage(systemName: "star")!
        
        imageManager.cacheImage(image, for: url)
        
        // Act
        let loadedImage = await imageManager.loadImage(from: url)
        
        // Assert
        XCTAssertNotNil(loadedImage)
    }
    
    func testClearCache() {
        // Arrange
        let url = "https://apple.com/img.png"
        let image = UIImage(systemName: "star")!
        
        imageManager.cacheImage(image, for: url)
        
        let cachedImageURL = cacheDirectoryURL.appendingPathComponent(url.hashValue.description)
        XCTAssertTrue(fileManager.fileExists(atPath: cachedImageURL.path), "cached image should exist in the cache directry")
        
        // Act
        imageManager.clearCache()
        
        let imageFromCache = imageManager.getImage(for: url)
        // Assert
        XCTAssertNil(imageFromCache)
        XCTAssertFalse(fileManager.fileExists(atPath: cachedImageURL.path), "Cache should be cleared, and image file should not exist.")
    }
    
    func testLoadImageFromNetwork_Success() async {
        // Arrange
        let url = "https://apple.com/image.png"
        
        // Mock image data: Use actual valid image data
        guard let image = UIImage(systemName: "star") else {
            XCTFail("Failed to create test image")
            return
        }
        guard let imageData = image.pngData() else {
            XCTFail("Failed to convert test image to PNG data")
            return
        }
        
        // Simulate network response
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        // Set the mock URL session data to be valid image data
        mockURLSession.data = imageData
        mockURLSession.response = response
        
        // Act
        let loadedImage = await imageManager.loadImage(from: url)
        
        // Assert
        XCTAssertNotNil(loadedImage)
    }
    
    func testLoadImageFromNetwork_Error() async {
        // Arrange
        let url = "https://apple.com/image.jpg"
        mockURLSession.error = NSError(domain: "NetworkError", code: 0, userInfo: nil)
        
        // Act
        let loadedImage = await imageManager.loadImage(from: url)
        
        // Assert
        XCTAssertNil(loadedImage)
    }
}

class MockImageLoader: ImageLoading {

    var imageToReturn: UIImage?
    
    func loadImage(from url: String) async -> UIImage? {
        return imageToReturn
    }
}

class MockImageCache: ImageCaching {

    var cachedImages: [String: UIImage] = [:]
    
    func getImage(for url: String) -> UIImage? {
        return cachedImages[url]
    }
    
    func cacheImage(_ image: UIImage, for url: String) {
        cachedImages[url] = image
    }
    
    func clearCache() { }
}
