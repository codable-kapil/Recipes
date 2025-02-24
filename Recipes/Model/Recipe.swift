//
//  Recipe.swift
//  Recipes
//
//  Created by Kapil Shivhare on 2/20/25.
//

import Foundation

struct RecipesResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Identifiable, Codable {
    var id: String { uuid }
    let uuid: String
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?
}
