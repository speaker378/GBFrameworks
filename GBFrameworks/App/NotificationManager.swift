//
//  NotificationManager.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 30.06.2022.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    static let share = NotificationManager()
    let center = UNUserNotificationCenter.current()

    private init() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Разрешение получено.")
            } else {
                print("Разрешение НЕ получено.")
            }
        }
    }

    private func makeNotificationContent(title: String, subtitle: String, body: String, badge: UInt) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = (badge) as NSNumber
        return content
    }

    private func makeIntervalNotificationTrigger(timeSlot: Double) -> UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: timeSlot, repeats: false)
    }

    private func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Ошибка: ", error.localizedDescription)
            }
        }
    }

    func sendNotification(title: String, subtitle: String, body: String, timeSlot: Double, badge: UInt) {
        center.getNotificationSettings { [unowned self] settings in
            guard settings.authorizationStatus == .authorized else { return }
            self.sendNotificationRequest(
                content: self.makeNotificationContent(title: title, subtitle: subtitle, body: body, badge: badge),
                trigger: self.makeIntervalNotificationTrigger(timeSlot: timeSlot)
            )
        }
    }

    func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
