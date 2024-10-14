
import Foundation
import UIKit

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchAllCountries() async throws -> [[CountryListModel]] {
        
        //https://restcountries.com/v3.1/all
        //https://restcountries.com/v3.1/region/europe
        
        let urlString = "https://restcountries.com/v3.1/all"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parsedData = try JSONDecoder().decode([CountryModel].self, from: data)
            
            let fetchedDataWithImages = try await fetchCountryImages(valueArr: parsedData)
            let sortedCountries = sortDataSource(valueArr: fetchedDataWithImages)
            return sortedCountries
            
        } catch {
            print(error)
            throw URLError(.cannotParseResponse)
        }
    }
    
    func fetchCountryByCode(code: String) async throws -> [FinalCountryDetails] {
        
        //https://restcountries.com/v3.1/alpha/GS
        
        let urlString = "https://restcountries.com/v3.1/alpha/\(code)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let parsedData = try JSONDecoder().decode([CountryDetailsModel].self, from: data)
            
            let finalData = getCountryFlag(valueArr: parsedData, code: code)
            return finalData

            
        } catch {
            print(error)
            throw URLError(.cannotParseResponse)
        }
        
    }
    
    private func fetchCountryImages(valueArr: [CountryModel]) async throws -> [CountryListModel]{
        
        var countriesWithImage = [CountryListModel]()
        var regionSet = Set<String>()
        
        await withTaskGroup(of: CountryListModel?.self) { taskGroup in
            for countryModel in valueArr {
                taskGroup.addTask { [weak self] in
                    do {
                        
                        let capital = self?.combineStringValues(countryArr: countryModel.capital ?? []) ?? "Unknown Capital"
                        let currencies = self?.combineCurrenyValues(currencyDict: countryModel.currencies ?? [:]) ?? "Unknown Currency"
                            
        
                        
                        if let cachedImage = CacheManager.shared.getCacheObject(forKey: countryModel.name.common) {
                            
                            print("Png was retrieved from cache")
                            return CountryListModel(name: countryModel.name.common, capital: capital, population: countryModel.population, region: countryModel.region, flag: cachedImage, currencies: currencies, cca2: countryModel.cca2)
                        }
                        
                        let urlString = countryModel.flags.png
                        guard let url = URL(string: urlString) else {
                            throw URLError(.badURL)
                        }
                        

                        let (data, _) = try await URLSession.shared.data(from: url)
                        guard let fetchedImage = UIImage(data: data) else {
                            throw URLError(.cannotDecodeContentData)
                        }
                        
                        CacheManager.shared.setCacheObject(object: fetchedImage, forKey: countryModel.name.common)
                        return CountryListModel(name: countryModel.name.common, capital: capital, population: countryModel.population, region: countryModel.region, flag: fetchedImage, currencies: currencies, cca2: countryModel.cca2)
                        
                    } catch {
                        print("Failed to fetch image for \(countryModel.name): \(error.localizedDescription)")
                        return nil
                    }
                }
            }
            
            for await result in taskGroup {
                if let currentValue = result {
                    countriesWithImage.append(currentValue)
                    regionSet.insert(currentValue.region)
                }
            }
        }
        
        
        return countriesWithImage
        
    }
    
    func openGoogleMapsInBrowser(latitude: Double, longitude: Double) {
           let urlString = "https://www.google.com/maps?q=\(latitude),\(longitude)"
           
           if let url = URL(string: urlString) {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                   // Handle the case where the URL cannot be opened
                   print("Cannot open URL.")
               }
           }
       }
    
    private func getCountryFlag(valueArr: [CountryDetailsModel], code: String) -> [FinalCountryDetails] {
        
        var finalCountries: [FinalCountryDetails] = []
           
           for country in valueArr {
               let cachedImage = CacheManager.shared.getCacheObject(forKey: country.name.common)
               let capital = combineStringValues(countryArr: country.capital ?? [])
               let subregion = country.subregion ?? "zero subregion"
               let currencies = combineCurrenyValues(currencyDict: country.currencies ?? [:])
               let timezones = combineStringValues(countryArr: country.timezones)
               
               let finalCountry = FinalCountryDetails(
                   name: country.name.common,
                   capital: capital,
                   capitalInfo: country.capitalInfo,
                   population: country.population,
                   subregion: subregion,
                   area: country.area,
                   flag: cachedImage ?? UIImage(systemName: "flag")!,
                   currencies: currencies,
                   timezones: timezones
               )
               
               finalCountries.append(finalCountry)
           }
           
           return finalCountries
        
    }
    
    private func combineStringValues(countryArr: [String]) -> String {
        switch countryArr.count {
        case 0:
            return "no capital"
        case 1:
            return countryArr[0]
        default:
            return countryArr.joined(separator: "\n")
        }
    }
    
    private func combineCurrenyValues(currencyDict: [String: CurrencyModel]) -> String {
        switch currencyDict.count {
        case 0:
            return "no currency"
        case 1:
            guard let firstValue = currencyDict.first else { return ""}
            return "\(firstValue.value.name) (\(firstValue.value.symbol)) (\(firstValue.key))"
            
        default:
            var combinedString = ""
            for (key, value) in currencyDict {
                let formattedCurrency = "\(value.name) (\(value.symbol)) (\(key))"
                if combinedString.isEmpty {
                    combinedString = formattedCurrency
                } else {
                    combinedString += "\n" + formattedCurrency
                }
            }
            
            return combinedString
            
        }
        
    }
    
    private func sortDataSource(valueArr: [CountryListModel]) -> [[CountryListModel]] {
        
        var dict = [String: [CountryListModel]]()
        var dataSourceArr = [[CountryListModel]]()
        
        for country in valueArr {
            if var existingValue = dict[country.region] {
                existingValue.append(country)
                dict[country.region] = existingValue
            } else {
                dict[country.region] = [country]
            }
        }
        
        
        for (_, value) in dict {
            dataSourceArr.append(value)
        }
        
        return dataSourceArr
    }
}


