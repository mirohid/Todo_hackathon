//
//  NotificationManager.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//


import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    /// Schedules a local notification for a task before the end of today.
    /// - Parameters:
    ///   - title: Task title to show in the notification body.
    ///   - date: Desired reminder time (must be today). If the date is in the past,
    ///           it will be nudged a minute into the future.
    func scheduleReminder(for title: String, at date: Date) {

        let now = Date()
        let endOfDay = now.endOfDay

        // Ensure the reminder always fires in the future and never after end of day.
        var scheduledDate = max(date, now.addingTimeInterval(60))
        if scheduledDate > endOfDay {
            scheduledDate = endOfDay
        }

        let content = UNMutableNotificationContent()
        content.title = "Today's Task"
        content.body = title
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.hour, .minute],
            from: scheduledDate
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}