import Foundation
import Combine

class IceReportDetailViewModel: ObservableObject {
    
    @Published var summary: IceReportSummary
    
    let service: IceReportService
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(summary: IceReportSummary, service: IceReportService) {
        self.summary = summary
        self.service = service
        setupSubscribers()
    }
    
    func didPressSave(name: String, status: IceReportStatus) {
        guard !name.isEmpty else {
            return
        }
        Task { @MainActor in
            let iceReport = IceReport(reporter: name, status: status, date: .now)
            try? await service.addReport(summary.id, iceReport)
        }
    }
    
    private func setupSubscribers() {
        service.reportsChanged
            .flatMap {
                $0.publisher
            }
            .filter { [summary] in
                $0.id == summary.id
            }
            .sink { [weak self] in
                self?.summary = $0
            }
            .store(in: &cancellables)
    }
}
