//
//  Model.swift
//  Rick and Morty
//
//  Created by Bill Vivino on 8/2/22.
//

import Foundation

public struct RickAndMorty: Codable {
    var results: [ResultArray]
}

struct ResultArray: Codable {
    var id: Int
    var name: String
    var status: String
    var species: String
}

