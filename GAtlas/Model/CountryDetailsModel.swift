//
//  CountryDetails.swift
//  GAtlas
//
//  Created by Damir Agadilov  on 14.09.2024.
//

import Foundation
import UIKit

struct CountryDetailsModel: Decodable {
    let name: NameModel
    let capital: [String]?
    let capitalInfo: [String: [Double]]
    let population: Int
    let subregion: String?
    let area: Double
    let currencies: [String: CurrencyModel]?
    let timezones: [String]
}

struct FinalCountryDetails {
    let name: String
    let capital: String
    let capitalInfo: [String: [Double]]
    let population: Int
    let subregion: String
    let area: Double
    let flag: UIImage
    let currencies: String
    let timezones: String
    
    func countOfProperties() -> Int {
        let mirror = Mirror(reflecting: self)
        return mirror.children.count
    }
}
