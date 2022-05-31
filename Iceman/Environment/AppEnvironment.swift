import Foundation
import Environment
import Analytics

@dynamicMemberLookup
struct AppEnvironment {
    var analytics = AnalyticsEventService.live
}

extension AppEnvironment: EnvironmentRepresentable {
    static let environment = EnvironmentBuilder.build(AppEnvironment())
}
