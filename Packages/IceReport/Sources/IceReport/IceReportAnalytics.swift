import Foundation
import Analytics
import Environment

extension AnalyticsEvent {
    static func changeSorting(sortingOption: IceReportViewModel.SortingOption) -> Self {
        return .init(name: "Changed sorting", properties: ["sortingOption": sortingOption.rawValue])
    }
}
