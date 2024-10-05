//
//  Untitled.swift
//  Nation
//
//  Created by Anderson Bressane on 05/10/2024.
//

struct Nation: ModelProtocol {
    let id: String
    let name: String
    let idYear: Int
    let year: String
    let population: Int
    let slug: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID Nation"
        case name = "Nation"
        case idYear = "ID Year"
        case year = "Year"
        case population = "Population"
        case slug = "Slug Nation"
    }
}
