//
//  LayoutViewModel.swift
//  Nation
//
//  Created by Anderson Bressane on 07/10/2024.
//

class LayoutViewModel {
    var id: String
    var name: String
    var idYear: Int
    var year: String
    var population: Int
    var slug: String
    var type: ModelType
    
    init(model: ModelProtocol) {
        id = model.id
        name = model.name
        idYear = model.idYear
        year = model.year
        population = model.population
        slug = model.slug
        type = model.type
    }
}
