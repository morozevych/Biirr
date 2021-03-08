//
//  Beer.swift
//  InfiniumTest
//
//  Created by andrii on 06/03/2021.
//

import Foundation

struct BeerResponse: Codable {
    var data:[Beer]?
}

struct Beer: Codable {
    let id, name, nameDisplay, beerDescription: String?
    let abv, ibu: String?
    let styleID: Int?
    let isOrganic, isRetired: String?
    let labels: Labels?
    let style: Style?
    
    enum CodingKeys: String, CodingKey {
        case id, name, nameDisplay
        case beerDescription = "description"
        case abv, ibu
        case styleID = "styleId"
        case isOrganic, isRetired, labels, style
    }
}

// MARK: - Labels
struct Labels: Codable {
    let icon, medium, large, contentAwareIcon: String?
    let contentAwareMedium, contentAwareLarge: String?
}

// MARK: - Style
struct Style: Codable {
    let id, categoryID: Int?
    let category: Category?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "categoryId"
        case category
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name, createDate: String?
}
