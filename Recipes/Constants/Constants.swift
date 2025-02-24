//
//  Constants.swift
//  Recipes
//
//  Created by Kapil Shivhare on 2/21/25.
//

import Foundation

enum Constants {
    
    enum Endpoint {
        static let recipes          = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        // Use the below endpoints for testime purpose:
        static let malformedRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        static let emptyRecipes     = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    }
    
    enum APIErrorMessage {
        static let invalidURL       = "The URL provided is invalid"
        static let invalidResponse  = "Server returned an invalid response"
        static let invalidData      = "Server retuned invalid data"
        static let failedToDecode   = "Failed to decode response from server"
    }
    
    enum UserMessage {
        static let noRecipes        = NSLocalizedString("No recipes available.", comment: "No recipes message")
        static let networkError     = NSLocalizedString("Failed to load recipes. Please try again.", comment: "Network Error message")
        static let loading          = NSLocalizedString("Loading", comment: "The app is loading data.")
    }
}
