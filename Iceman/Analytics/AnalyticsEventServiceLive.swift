import Foundation
import Analytics

extension AnalyticsEventService {
    static var live: AnalyticsEventService {
        return AnalyticsEventService(track: { event in
            // TODO: Hook up with real analytics provider
        })
    }
}
