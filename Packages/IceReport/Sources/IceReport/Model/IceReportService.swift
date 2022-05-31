import Foundation
import Combine

public struct IceReportService {
    public let getReports: () async throws -> [IceReportSummary]
    public let reportsChanged: AnyPublisher<[IceReportSummary], Never>
    public let addReport: (_ summaryID: String, IceReport) async throws -> Void
    
    public init(getReports: @escaping () async throws -> [IceReportSummary], reportsChanged: AnyPublisher<[IceReportSummary], Never>, addReport: @escaping (String, IceReport) async throws -> Void) {
        self.getReports = getReports
        self.reportsChanged = reportsChanged
        self.addReport = addReport
    }
}

public extension IceReportService {
    static var mockSuccessWithLoading: IceReportService {
        var summaries: [IceReportSummary] = .iceReportsMock
        
        let subject = PassthroughSubject<[IceReportSummary], Never>()
        var firstTime = true
        
        return IceReportService(
            getReports: {
                if firstTime {
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                }
                firstTime = false
                return summaries
            },
            reportsChanged: subject.eraseToAnyPublisher(),
            addReport: { summaryID, newReport in
                if let index = summaries.firstIndex(where: { $0.id == summaryID}) {
                    summaries[index].reports.append(newReport)
                    subject.send(summaries)
                }
            }
        )
    }
    
    static var mockInstantSuccess: IceReportService {
        var summaries: [IceReportSummary] = .iceReportsMock
        
        let subject = PassthroughSubject<[IceReportSummary], Never>()
        
        return IceReportService(
            getReports: {
                return summaries
            },
            reportsChanged: subject.eraseToAnyPublisher(),
            addReport: { summaryID, newReport in
                if let index = summaries.firstIndex(where: { $0.id == summaryID}) {
                    summaries[index].reports.append(newReport)
                    subject.send(summaries)
                }
            }
        )
    }
    
    static var mockFailureWithLoading: IceReportService {
        return IceReportService(
            getReports: {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                throw NSError(domain: "Failed", code: 401, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
            },
            reportsChanged: Empty().eraseToAnyPublisher(),
            addReport: { _, _ in})
    }
}
