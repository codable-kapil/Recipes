//
//  RecipesApp.swift
//  Recipes
//
//  Created by Kapil Shivhare on 2/20/25.
//

import SwiftUI

@main
struct RecipesApp: App {

    // RecipeListViewModel dependencies
    private var recipeService: RecipeService
    private var imageManager: ImageLoading
    
    init() {
        self.recipeService = NetworkManager()
        self.imageManager = ImageManager()
    }
    
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: RecipeListViewModel(recipeService: recipeService, imageManager: imageManager))
        }
    }
}
