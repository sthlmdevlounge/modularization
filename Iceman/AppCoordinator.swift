import Foundation
import Coordinator
import UIKit
import IceReport

class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let tabBarController: UITabBarController
    private var iceReportCoordinator: IceReportCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        tabBarController = UITabBarController()
    }
    
    func start() {
        window.rootViewController = tabBarController
        let navigationController = UINavigationController()
        tabBarController.setViewControllers([navigationController], animated: true)
        setupIceReportCoordinator(navigationController)
        window.makeKeyAndVisible()
        iceReportCoordinator?.start()
    }
    
    private func setupIceReportCoordinator(_ navigationController: UINavigationController) {
        let environment = IceReportEnvironment(analytics: AppEnvironment.analytics)
        IceReportEnvironment.environment.replace(environment)
        self.iceReportCoordinator = IceReportCoordinator(navigationController:navigationController, service: .live)
    }
}
