//
//  RecipeListView.swift
//  Recipes
//
//  Created by Kapil Shivhare on 2/20/25.
//

import SwiftUI

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                    
                case .loading:
                    // Shows a loading spinner while fetching recipes
                    ProgressView(Constants.UserMessage.loading)
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.2)
                        .padding()
                    
                case .error(let message):
                    // Shows the error message with retry button
                    ErrorView(message: message, viewModel: viewModel)
                    
                case .empty(let message):
                    // Shows empty state message if no recipes are available
                    EmptyView(message: message)
                    
                case .loaded:
                    // Shows list with the recipes once the data is available
                    List(viewModel.recipes) { recipe in
                        RecipeListRowView(recipe: recipe, viewModel: viewModel)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Recipes")
            .onAppear {
                if viewModel.recipes.isEmpty {
                    Task {
                        await viewModel.getRecipes()
                    }
                }
            }
            .refreshable {
                await viewModel.getRecipes()
            }
        }
    }
}

#Preview {
    RecipeListView(viewModel: RecipeListViewModel(recipeService: NetworkManager(), imageManager: ImageManager()))
}

struct ErrorView: View {
    
    let message: String
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Button(action: {
                Task {
                    await viewModel.getRecipes()
                }
            }) {
                if viewModel.state == .loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Retry")
                        .font(.body)
                }
            }
            .padding()
            .background(Color.secondary)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

struct EmptyView: View {
    let message: String
    var body: some View {
        VStack {
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}
