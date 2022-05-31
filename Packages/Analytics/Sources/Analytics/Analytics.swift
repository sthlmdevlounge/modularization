
public struct AnalyticsEvent: Equatable {
    public let name: String
    public let properties: [String: AnyHashable]?
    
    public init(name: String, properties: [String: AnyHashable]? = nil) {
        self.name = name
        self.properties = properties
    }
}

public struct AnalyticsEventService {
    public var track: (AnalyticsEvent) -> Void
    public init(track: @escaping (AnalyticsEvent) -> Void) {
        self.track = track
    }
}

public extension AnalyticsEventService {
    static var printMock: AnalyticsEventService {
        return AnalyticsEventService(
            track: { event in
                print("Analytics event - eventName: \(event.name), properties: \(String(describing: event.properties))")
            }
        )
    }
}
