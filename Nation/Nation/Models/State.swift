//
//  State.swift
//  Nation
//
//  Created by Anderson Bressane on 05/10/2024.
//

struct State: ModelProtocol {
    let id: String
    let name: String
    let idYear: Int
    let year: String
    let population: Int
    let slug: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID State"
        case name = "State"
        case idYear = "ID Year"
        case year = "Year"
        case population = "Population"
        case slug = "Slug State"
    }
}

