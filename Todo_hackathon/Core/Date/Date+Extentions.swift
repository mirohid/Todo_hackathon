//
//  Date+Extentions.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//

import Foundation

extension Date {

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        Calendar.current.date(
            byAdding: DateComponents(day: 1, second: -1),
            to: startOfDay
        )!
    }

    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}
