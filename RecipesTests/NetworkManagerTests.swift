//
//  NetworkManagerTests.swift
//  RecipesTests
//
//  Created by Kapil Shivhare on 2/22/25.
//

import XCTest
@testable import Recipes

final class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!
    var mockURLSession: MockURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockURLSession = MockURLSession()
        networkManager = NetworkManager(urlSession: mockURLSession)
    }

    override func tearDownWithError() throws {
        networkManager = nil
        mockURLSession = nil
        try super.tearDownWithError()
    }

    func testGetRecipes_Success() async {
        // Arrange
        let expectedRecipes = [Recipe(uuid: "AMIHD2449", cuisine: "Indian", name: "Chicken Tikka Masala", photoUrlLarge: nil, photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/2cac06b3-002e-4df7-bb08-e15bbc7e552d/small.jpg", sourceUrl: nil, youtubeUrl: nil)]
        
        // Simulate network response
        let data = try! JSONEncoder().encode(RecipesResponse(recipes: expectedRecipes))
        let response = HTTPURLResponse(url: URL(string: "https://apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
                
        mockURLSession.data = data
        mockURLSession.response = response
        // Act
        do {
            let recipes = try await networkManager.getRecipes()
            
            // Assert
            XCTAssertEqual(recipes.count, 1)
            XCTAssertEqual(recipes.first?.name, "Chicken Tikka Masala")
        } catch {
            XCTFail("Fetch failed with error: \(error)")
        }
    }

    func testGetRecipes_Failure() async {
        // Arrange
        mockURLSession.error = NSError(domain: "NetworkError", code: 0, userInfo: nil)
        
        // Act
        do {
            _ = try await networkManager.getRecipes()
            XCTFail("Expected failure, but fetch succeeded")
        } catch {
            // Assert
            XCTAssertNotNil(error)
        }
    }
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw NetworkError.invalidData
        }
        return (data, response)
    }
}
