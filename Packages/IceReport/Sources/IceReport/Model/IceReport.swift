//
//  File.swift
//  
//
//  Created by Johan Thorell on 2022-05-25.
//

import Foundation

public struct IceReport: Equatable, Identifiable {
    public let reporter: String
    public let status: IceReportStatus
    public let date: Date
    public var id: String {
        return reporter + status.rawValue + date.description
    }
    
    public init(reporter: String, status: IceReportStatus, date: Date) {
        self.reporter = reporter
        self.status = status
        self.date = date
    }
}

extension IceReport {
    static var mockGood: IceReport {
        return .init(reporter: "Johan", status: .good, date: .now)
    }
    static var mockWarning: IceReport {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return .init(reporter: "Lisa", status: .warning, date: yesterday)
    }
    static var mockDanger: IceReport {
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        return .init(reporter: "Mr. T", status: .danger, date: twoDaysAgo)
    }
}
