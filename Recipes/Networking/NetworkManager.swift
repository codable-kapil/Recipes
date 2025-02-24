//
//  NetworkManager.swift
//  Recipes
//
//  Created by Kapil Shivhare on 2/20/25.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

/// Protocol that a confirming class can implement to get the recipes from network
protocol RecipeService {
    func getRecipes() async throws -> [Recipe]
}

/// An enum to represent different type of network errors
enum NetworkError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case invalidData
    case failedToDecode(originalError: Error)
    
    var localizedDescription: String {
        switch self {
            
        case .invalidURL:
            return Constants.APIErrorMessage.invalidURL
        case .invalidResponse(let statusCode):
            return "\(Constants.APIErrorMessage.invalidResponse) : \(statusCode)"
        case .invalidData:
            return Constants.APIErrorMessage.invalidData
        case .failedToDecode(let originalError):
            return "\(Constants.APIErrorMessage.failedToDecode) : \(originalError.localizedDescription)"
        }
    }
}

class NetworkManager: RecipeService {
    
    private var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    /// Gets the recipes from the endpoint asynchronously
    /// - Returns: Array of type Recipe
    func getRecipes() async throws -> [Recipe] {
        
        guard let url = URL(string: Constants.Endpoint.recipes) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: 0)
        }
        
        guard response.statusCode == 200 else {
            throw NetworkError.invalidResponse(statusCode: response.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let apiResponse = try decoder.decode(RecipesResponse.self, from: data)
            return apiResponse.recipes
        } catch {
            throw NetworkError.failedToDecode(originalError: error)
        }
    }
}
