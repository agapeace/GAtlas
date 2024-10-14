
import Foundation
import UIKit

struct CountryModel: Decodable {
    let name: NameModel
    let capital: [String]?
    let population: Int
    let region: String
    let flags: FlagModel
    let currencies: [String: CurrencyModel]?
    let cca2: String
}

struct NameModel: Decodable {
    let common: String
}

struct FlagModel: Decodable {
    let png: String
}

struct CurrencyModel: Decodable {
    let name: String
    let symbol: String
}



struct CountryListModel {
    let name: String
    let capital: String
    let population: Int
    let region: String
    let flag: UIImage
    let currencies: String
    let cca2: String
    var isExpanded: Bool = false
}

