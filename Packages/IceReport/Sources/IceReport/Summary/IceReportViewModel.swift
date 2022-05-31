import Foundation
import Combine
import SwiftUI

@MainActor
public class IceReportViewModel: ObservableObject {
    
    public enum SortingOption: String, Equatable {
        case location = "Location"
        case alphabetical = "Alphabetical"
        
        var iconName: String {
            switch self {
            case .location:
                return "location"
            case .alphabetical:
                return "textformat.abc"
            }
        }
        
        func sortedBy(lhs: IceReportSummary, rhs: IceReportSummary) -> Bool {
            switch self {
            case .location:
                return lhs.distanceFromInMeters < rhs.distanceFromInMeters
            case .alphabetical:
                return lhs.name < rhs.name
            }
        }
    }

    enum State {
        case loading
        case failure(Error)
        case success([IceReportSummary])
    }
    
    @Published var state: State = .loading
        
    private let service: IceReportService
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var sortingOption = SortingOption.location {
        didSet {
            if case .success(let iceReports) = state {
                IceReportEnvironment.analytics.track(.changeSorting(sortingOption: sortingOption))
                withAnimation {
                    state = .success(iceReports.sorted(by: sortingOption.sortedBy(lhs:rhs:)))
                }
            }
        }
    }
    
    public init(service: IceReportService) {
        self.service = service
        setupSubscribers()
    }
    
    public func handleSorting(_ sortingOption: SortingOption) {
        self.sortingOption = sortingOption
    }
    
    public func getReports() async {
        state = .loading
        do {
            let reports = try await service.getReports()
            state = .success(sort(reports))
        } catch {
            state = .failure(error)
        }
    }
    
    private func setupSubscribers() {        
        service.reportsChanged
            .sink { [weak self] summaries in
                guard let self = self else {
                    return
                }
                self.state = .success(self.sort(summaries))
            }
            .store(in: &cancellables)
    }
    
    private func sort(_ summaries: [IceReportSummary]) -> [IceReportSummary] {
        return summaries.sorted(by: self.sortingOption.sortedBy(lhs:rhs:))
    }
}
