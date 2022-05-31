import Coordinator
import UIKit
import SwiftUI
import SwiftUIHelpers

@MainActor
public class IceReportCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let service: IceReportService
    private var iceReportViewModel: IceReportViewModel?
    
    private lazy var rightBarButtonItemReports: UIBarButtonItem = {
        let alphabetical = UIAction(title: "Alphabetical", image: UIImage(systemName: "textformat.abc")) { [weak self] _ in
            self?.iceReportViewModel?.handleSorting(.alphabetical)
        }
        let location = UIAction(title: "Location", image: UIImage(systemName: "location")) { [weak self] _ in
            self?.iceReportViewModel?.handleSorting(.location)
        }
        let menu = UIMenu(title: "Sorting", children: [alphabetical, location])
        let barButtomItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.up.arrow.down.circle"), primaryAction: nil, menu: menu)
        
        return barButtomItem
    }()
    
    public init(navigationController: UINavigationController, service: IceReportService) {
        self.navigationController = navigationController
        self.service = service
    }
    
    public func start() {
        let viewModel = IceReportViewModel(service: service)
        iceReportViewModel = viewModel
        let view = IceReportsView(viewModel: viewModel, coordinator: self)
        let hostingController = UIHostingController(rootView: view)
        hostingController.navigationItem.rightBarButtonItem = rightBarButtonItemReports
        hostingController.title = "Ice Reports"
        navigationController.viewControllers = [hostingController]
    }
    
    func didPressSummary(_ summary: IceReportSummary) {
        let viewModel = IceReportDetailViewModel(summary: summary, service: service)
        let view = IceReportDetailView(coordinator: self, viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = summary.name
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func didPressAddNewReport(didAdd: @escaping (AddReportView.State) -> Void) {
        let observing = Observing(value: AddReportView.State(name: "", status: .good))
        var vc: UIViewController?
        let view = AddReportView(observed: observing, didPressSave: {
            didAdd($0)
            vc?.dismiss(animated: true)
        })
        let hostingController = UIHostingController(rootView: view)
        vc = hostingController
        navigationController.present(hostingController, animated: true)
    }
}

#if DEBUG
public class MockCoordinator: AbstractMockCoordinator {
    public override class func create() -> AbstractMockCoordinator {
        let navigationController = UINavigationController()
        let coordinator = IceReportCoordinator(navigationController: navigationController, service: .mockInstantSuccess)
        return AbstractMockCoordinator(navigationController: navigationController, coordinator: coordinator)
    }
}
#endif
