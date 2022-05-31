import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    func start()
}

#if DEBUG
@MainActor
open class AbstractMockCoordinator {
    
    public let navigationController: UINavigationController
    public let coordinator: Coordinator
    
    open class func create() -> AbstractMockCoordinator {
        fatalError("Must be overriden")
    }
    
    public init(navigationController: UINavigationController, coordinator: Coordinator) {
        self.navigationController = navigationController
        self.coordinator = coordinator
    }
}
#endif
