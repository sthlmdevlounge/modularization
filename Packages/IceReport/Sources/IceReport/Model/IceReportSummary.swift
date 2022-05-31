//
//  File.swift
//  
//
//  Created by Johan Thorell on 2021-12-06.
//

import Foundation
import SwiftUI

public enum IceReportStatus: String, Equatable, CaseIterable {
    case good = "Good"
    case warning = "Warning"
    case danger = "Danger"
    
    var iconName: String {
        switch self {
        case .good:
            return "hand.thumbsup.circle"
        case .warning:
            return "exclamationmark.circle.fill"
        case .danger:
            return "nosign"
        }
    }
    
    var color: Color {
        switch self {
        case .good:
            return .green
        case .warning:
            return .yellow
        case .danger:
            return .red
        }
    }
}

public struct IceReportSummary: Identifiable, Equatable {
    public let name: String
    public let distanceFromInMeters: Double
    public let status: IceReportStatus
    public let id: String
    public var reports: [IceReport]
    public var distanceString: String {
        let measurement = Measurement(value: distanceFromInMeters, unit: UnitLength.meters)
        if distanceFromInMeters < 1000 {
            return measurement.formatted()
        } else {
            let converted = measurement.converted(to: UnitLength.kilometers)
            return converted.formatted()
        }
    }
}

extension IceReportSummary {
    static var mockGood: IceReportSummary {
        return IceReportSummary(name: "Dammtorpssjön",
                                distanceFromInMeters: 245,
                                status: .good,
                                id: "A",
                                reports: [.mockGood])
    }
    static var mockGood2: IceReportSummary {
        return IceReportSummary(name: "Sommen",
                                distanceFromInMeters: 35000,
                                status: .good,
                                id: "B",
                                reports: [.mockGood])
    }
    static var mockDanger: IceReportSummary {
        return IceReportSummary(name: "Söderbysjön",
                                distanceFromInMeters: 400,
                                status: .danger,
                                id: "C",
                                reports: [.mockDanger, .mockWarning])
    }
    static var mockDanger2: IceReportSummary {
        return IceReportSummary(name: "Siljan",
                                distanceFromInMeters: 53000,
                                status: .danger,
                                id: "D",
                                reports: [.mockDanger])
    }
    static var mockWarning: IceReportSummary {
        return IceReportSummary(name: "Källtorpssjön",
                                distanceFromInMeters: 122,
                                status: .warning,
                                id: "E",
                                reports: [.mockWarning])
    }
    static var mockWarningLongDistance: IceReportSummary {
        return IceReportSummary(name: "Lädesjön",
                                distanceFromInMeters: 55000,
                                status: .warning,
                                id: "F",
                                reports: [.mockWarning])
    }
}

public extension Array where Element == IceReportSummary {
    static var iceReportsMock: [IceReportSummary] {
        return [
            .mockGood,
            .mockGood2,
            .mockDanger,
            .mockDanger2,
            .mockWarning,
            .mockWarningLongDistance
        ]
    }
}
