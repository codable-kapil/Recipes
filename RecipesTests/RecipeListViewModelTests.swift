//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Kapil Shivhare on 2/20/25.
//

import XCTest
import SwiftUI
@testable import Recipes

final class RecipeListViewModelTests: XCTestCase {

    var viewModel: RecipeListViewModel!
    var mockRecipeService: MockRecipeService!
    var mockImageLoader: MockImageLoader!
    var mockImageCache: MockImageCache!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        mockRecipeService = MockRecipeService()
        mockImageLoader = MockImageLoader()
        mockImageCache = MockImageCache()
        
        viewModel = RecipeListViewModel(recipeService: mockRecipeService, imageManager: mockImageLoader)
    }

    override func tearDownWithError() throws {
        mockRecipeService = nil
        mockImageLoader = nil
        mockImageCache = nil
        viewModel = nil
        
        try super.tearDownWithError()
    }

    func testGetRecipes_Success() async throws {
        
        let expectedRecipe = Recipe(uuid: "AMIHD2449", cuisine: "American", name: "Apple Pie", photoUrlLarge: nil, photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/2cac06b3-002e-4df7-bb08-e15bbc7e552d/small.jpg", sourceUrl: nil, youtubeUrl: nil)
        
        mockRecipeService.recipes = [expectedRecipe]
        XCTAssertEqual(viewModel.state, .loading)
        
        await viewModel.getRecipes()
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.name, "Apple Pie")
        XCTAssertEqual(viewModel.recipes.first?.cuisine, "American")
    }
    
    func testGetRecipes_Failure() async throws {
        
        mockRecipeService.error = NetworkError.invalidResponse(statusCode: 500)
        
        await viewModel.getRecipes()
        
        XCTAssertEqual(viewModel.state, .error(Constants.UserMessage.networkError))
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
    
    func testState_Empty() async throws {
        
        mockRecipeService.recipes = []
        
        await viewModel.getRecipes()
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertEqual(viewModel.state, .empty(Constants.UserMessage.noRecipes))
    }
    
    func testLoadImage() async throws {
        
        let expectedRecipe = Recipe(uuid: "AMIHD2449", cuisine: "American", name: "Apple Pie", photoUrlLarge: nil, photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/2cac06b3-002e-4df7-bb08-e15bbc7e552d/small.jpg", sourceUrl: nil, youtubeUrl: nil)

        
        let mockImage = UIImage(systemName: "star")
        let key = expectedRecipe.photoUrlSmall
        mockImageCache.cachedImages = [key!: mockImage!]
        
        let _ = await viewModel.getImage(from: key!)
        
        XCTAssertEqual(mockImageCache.cachedImages.count, 1)
        XCTAssertEqual(mockImageCache.cachedImages[expectedRecipe.photoUrlSmall!], mockImage)
    }
}

// MARK: - Mock Classes

class MockRecipeService: RecipeService {
    
    var recipes: [Recipe] = []
    var error: Error?
    
    func getRecipes() async throws -> [Recipe] {
        if let error = error {
            throw error
        }
        return recipes
    }
}
