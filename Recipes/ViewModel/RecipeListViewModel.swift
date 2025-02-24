//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by Kapil Shivhare on 2/20/25.
//

import Foundation
import SwiftUI

/// An enum representing different view states i.e, loading, loaded, error etc.
enum ViewState: Equatable {
    case loading
    case loaded
    case error(String)
    case empty(String)
}

class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var state: ViewState = .loading
    
    // Dependencies
    private let recipeService: RecipeService
    private let imageManager: ImageLoading
    
    init(recipeService: RecipeService, imageManager: ImageLoading) {
        self.recipeService = recipeService
        self.imageManager = imageManager
    }
    
    @MainActor
    /// Gets the recipes using network manager and sets the state and recipes accordingly to reflect changes in view
    func getRecipes() async {
        self.state = .loading
        
        do {
            let recipes = try await recipeService.getRecipes()
            self.state = recipes.isEmpty ? .empty(Constants.UserMessage.noRecipes) : .loaded
            self.recipes = recipes
        }
        catch {
            print("Error in getting recipes: \(error.localizedDescription)")
            self.state = .error(Constants.UserMessage.networkError)
        }
    }
    
    @MainActor
    /// Gets image using the ImageManager and returns it accordingly
    /// - Parameter url: URL String to download the image
    /// - Returns: An optional of type Image
    func getImage(from url: String) async -> Image? {
        guard let image = await imageManager.loadImage(from: url) else {
            return nil
        }
        return Image(uiImage: image)
    }
}
