import SwiftUI

@dynamicMemberLookup
public class Observing<Root>: ObservableObject {
    
    @Published public var value: Root
    
    public init(value: Root) {
        self.value = value
    }
    
    public subscript<T>(dynamicMember member: KeyPath<Root, T>) -> T {
        value[keyPath: member]
    }
    
    public subscript<T>(dynamicMember member: WritableKeyPath<Root, T>) -> T {
        get {
            value[keyPath: member]
        } set {
            value[keyPath: member] = newValue
        }
    }
}
