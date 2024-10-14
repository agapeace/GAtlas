//
//  CountryListViewModel.swift
//  GAtlas
//
//  Created by Damir Agadilov  on 16.09.2024.
//

import Foundation
import UIKit

class CountryListViewModel: NSObject, UNUserNotificationCenterDelegate{
    
    var observableValue: ObservableObject<CountryListModel> = ObservableObject(valueArr: [])
    private weak var currentViewController: UIViewController?
    
    func fetchAllCountries(collectionView: UICollectionView) {
        Task { [weak self] in
            guard let self = self else { return }
            await collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .clouds), animation: nil, transition: .crossDissolve(0.25))
            self.observableValue.valueArr = try await NetworkService.shared.fetchAllCountries()
        }
    }
    
    func pushDetailsViewController(navigation: UIViewController, code: String) {
        
        let vc = CountryDetails(codeValue: code)
        
        navigation.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupNotificationCenter(viewController: UIViewController) {
        NotificationCenterManager.shared.checkForPermission(viewController: viewController)
        UNUserNotificationCenter.current().delegate = self
        self.currentViewController = viewController
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let viewController = currentViewController as? CountryList else {
            completionHandler()
            return
        }
        pushDetailsViewController(navigation: viewController, code: viewController.randomCountry?.cca2 ?? "GS")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    
}


