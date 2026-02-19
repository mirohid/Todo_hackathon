//
//  HapticManager.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//


import UIKit

final class HapticManager {

    static let shared = HapticManager()

    func success() {
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
    }

    func impact() {
        UIImpactFeedbackGenerator(style: .medium)
            .impactOccurred()
    }
}