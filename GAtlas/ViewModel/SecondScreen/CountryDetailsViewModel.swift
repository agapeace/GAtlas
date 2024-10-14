

import Foundation
import UIKit


class CountryDetailsViewModel {
    
    var value: ObservableCountryObject<FinalCountryDetails> = ObservableCountryObject(valueArr: [])
    
    func fetchCountryDetail(tableView: UITableView, code: String) {
        
        Task { [weak self] in
            await tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .clouds), animation: nil, transition: .crossDissolve(0.25))
            self?.value.valueArr = try await NetworkService.shared.fetchCountryByCode(code: code)
        }
    }
    
    func openGoogleMapsLocation(latitude: Double, longitude: Double) {
        NetworkService.shared.openGoogleMapsInBrowser(latitude: latitude, longitude: longitude)
    }
}
