import XCTest
@testable import IceReport
import Analytics

final class IceReportTests: XCTestCase {
    @MainActor
    func testShouldSendSortingAlphabeticalAnalytics() async throws {
        var incomingEvent: AnalyticsEvent?
        let service = AnalyticsEventService { event in
            incomingEvent = event
        }
        
        let environment = IceReportEnvironment(analytics: service)
        IceReportEnvironment.environment.replace(environment)
        
        let viewModel = IceReportViewModel(service: .mockInstantSuccess)
        await viewModel.getReports()
        viewModel.handleSorting(.alphabetical)
        
        XCTAssertEqual(incomingEvent, .changeSorting(sortingOption: .alphabetical))
    }
}
