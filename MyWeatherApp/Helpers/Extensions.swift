//
//  Extensions.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import Foundation

extension Double {
    // MARK: - Round off doubles
    func roundDouble() -> String {
        return String(format: "%.1f", self)
    }
}

extension Date {
    // MARK: - Get Difference between dates
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}
