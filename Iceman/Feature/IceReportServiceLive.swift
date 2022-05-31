import Foundation
import IceReport
import Combine

extension IceReportService {
    static var live: IceReportService {
        let api = IceReportAPI()
        let service = IceReportService(
            getReports: api.getReports,
            reportsChanged: api.reportsPublisher,
            addReport: api.addReport
        )
        return service
    }
}

// Ideally the API should have it's own model since we might
// want to use different sources in the future, such as a database.
class IceReportAPI {
    
    var reportsPublisher: AnyPublisher<[IceReportSummary], Never> {
        return subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<[IceReportSummary], Never>()
    private var summaries: [IceReportSummary] = .iceReportsMock
    
    func getReports() async throws -> [IceReportSummary] {
        // TODO: Make API request
        return summaries
    }
    
    func addReport(summaryID: String, report: IceReport) async throws {
        // TODO: Make API Request
        if let index = summaries.firstIndex(where: { $0.id == summaryID}) {
            summaries[index].reports.append(report)
            subject.send(summaries)
        }
    }
}
