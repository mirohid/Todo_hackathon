//
//  DateProviding.swift
//  Todo_hackathon
//
//  Created by Mir Ohid Ali  on 19/02/26.
//


import Foundation

protocol DateProviding {
    var now: Date { get }
}

struct SystemDateProvider: DateProviding {
    var now: Date { Date() }
}