//
//  RecipeListRowView.swift
//  Recipes
//
//  Created by Kapil Shivhare on 2/20/25.
//

import SwiftUI

struct RecipeListRowView: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeListViewModel
    @State private var recipeImage: Image?
    
    var body: some View {
        HStack {
            if let image = recipeImage {
                ImageView(image: image)
            } else {
                ImageView(image: Image("placeholder"))
            }
            VStack(alignment: .leading) {
                
                 Text(recipe.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(8)
                    .background(Color.secondary.opacity(0.7))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .onAppear {
            Task {
                if let image = await viewModel.getImage(from: recipe.photoUrlSmall ?? "") {
                    recipeImage = image
                }
            }
        }
    }
}

struct ImageView: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(8)
    }
}

#Preview {
    RecipeListRowView(recipe: mockData, viewModel: RecipeListViewModel(recipeService: NetworkManager(), imageManager: ImageManager()))
}


let mockData = Recipe(uuid: "sddwe323", cuisine: "American", name: "Pumpkin Pie", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/93e50ff1-bf1d-4f88-8978-e18e01d3231d/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/93e50ff1-bf1d-4f88-8978-e18e01d3231d/small.jpg", sourceUrl: "https://www.bbcgoodfood.com/recipes/1742633/pumpkin-pie", youtubeUrl: nil)
