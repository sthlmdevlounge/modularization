import Foundation
import Environment
import Analytics

@dynamicMemberLookup
public struct IceReportEnvironment {
    public var analytics: AnalyticsEventService
    public init(analytics: AnalyticsEventService) {
        self.analytics = analytics
    }
}

extension IceReportEnvironment {
    static var mock: IceReportEnvironment {
        return IceReportEnvironment(analytics: .printMock)
    }
}

extension IceReportEnvironment: EnvironmentRepresentable {
    public static let environment = EnvironmentBuilder.build(IceReportEnvironment.mock)
}

