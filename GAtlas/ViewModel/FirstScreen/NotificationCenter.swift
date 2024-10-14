//
//  NotificationCenter.swift
//  GAtlas
//
//  Created by Damir Agadilov  on 17.09.2024.
//

import Foundation
import UserNotifications
import UIKit

class NotificationCenterManager {
    
    static let shared = NotificationCenterManager()
    
    private init() {}
    
    func checkForPermission(viewController: UIViewController) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = viewController as? UNUserNotificationCenterDelegate
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.dispatchNotification(viewController: viewController)
                }
            case .denied:
                // Handle denied status if needed
                break
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification(viewController: viewController)
                    }
                }
            default:
                break
            }
        }
    }
    
    private func dispatchNotification(viewController: UIViewController) {
        guard let vc = viewController as? CountryList else { return }
        guard let randomCountryValue = vc.countryArr.randomElement()?.randomElement() else { return }
        vc.randomCountry = randomCountryValue
        
        guard let title = vc.randomCountry?.name,
              let capital = vc.randomCountry?.capital,
              let region = vc.randomCountry?.region else { return }
        
        let body = "\(capital) is located in \(region)"
            
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for 5 seconds from now")
            }
        }
    }
}
