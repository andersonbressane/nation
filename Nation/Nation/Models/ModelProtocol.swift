//
//  ModelProtocol.swift
//  Nation
//
//  Created by Anderson Bressane on 05/10/2024.
//

protocol ModelProtocol: Codable {
    var id: String { get }
    var name: String { get }
    var idYear: Int { get }
    var year: String { get }
    var population: Int { get }
    var slug: String { get }
}

