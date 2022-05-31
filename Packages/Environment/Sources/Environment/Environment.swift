
public protocol EnvironmentRepresentable {
    static var environment: Environment<Self> { get }
}

public struct Environment<T: EnvironmentRepresentable> {
    public struct StackState {
        var stack: () -> [T]
        var mutate: ((inout [T]) -> Void) -> Void
    }
    
    private let stackState: StackState
    
    public init(stackState: StackState) {
        self.stackState = stackState
    }
    
    public var current: T {
        return stackState.stack().last!
    }
    
    public func push(_ env: T) {
        stackState.mutate {
            $0.append(env)
        }
    }
    
    public func pop() -> T? {
        let last = stackState.stack().last
        stackState.mutate {
            $0.removeLast()
        }
        return last
    }
    
    public func replace(_ env: T) {
        stackState.mutate {
            $0.append(env)
            $0.remove(at: $0.count - 2)
        }
    }
}

public extension EnvironmentRepresentable {
    static subscript<T>(dynamicMember keyPath: KeyPath<Self, T>) -> T {
        return environment.current[keyPath: keyPath]
    }
}

public struct EnvironmentBuilder {
    public static func build<T: EnvironmentRepresentable>(_ environment: T) -> Environment<T> {
        var stack = [environment]
        let stackState = Environment<T>.StackState(
            stack: { stack },
            mutate: { transform in
                transform(&stack)
            }
        )
        return Environment<T>(stackState: stackState)
    }
}
