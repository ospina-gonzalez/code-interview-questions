import UIKit

/// Use a single array to implement _n_ stacks

/// This implementation uses the bare minimum amount of storage possible to solve the problem. This implementation is a FIFO stack.
///
/// **Data complexity**
///     - `Array` of fixed capacity configurable at `init`,  if we attempt to insert elements beyond its capacity it will simply throw and Error.
///     - Look up `Int` with a value of  _n_ indicating the number of stacks supported
public struct MultiStacks<V> {
    public enum MultiStacksError: Error {
        case stackIndexOutOfBounds
        case stackOutOfCapacity
    }

    private(set) var arr: [V?]
    private let numberOfStacks: Int
    private let capacity: Int // allows us to avoid calls to `Array.count`
    
    /// Initializes the `MultiStack`
    /// - Parameters:
    ///   - numberOfStacks: How many stacks to support in the `MultiStack`
    ///   - capacity: Internal capacity of the `MultiStack`
    public init(numberOfStacks: Int = 1, capacity: Int = 10) {
        self.numberOfStacks = numberOfStacks
        self.capacity = capacity
        arr = Array(repeating: nil, count: capacity)
    }
    
    /// Inserts a value into one of the stacks.
    ///
    /// Complexity: _O(n) _ where _n_ is the internal capacity of the `MultiStack`
    ///
    /// - Parameters:
    ///   - value: value to insert
    ///   - stack: index (1 based) indicating the stack onto which to add the value
    ///
    /// - Throws:
    ///   - `stackIndexOutOfBounds` if `stack` is more than the number of supported stacks configured a `init`
    ///   - `stackOutOfCapacity` if the internal Array capacity is infufficient to add the value
    public mutating func insert(value: V, intoStack stack: Int) throws {
        try validateStackIndex(stack)
        var index = stack - 1
        while index < capacity, arr[index] != nil {
            index += numberOfStacks
        }
        if index >= arr.count {
            throw MultiStacksError.stackOutOfCapacity
        }
        arr[index] = value
    }

    /// Pops (removes and returns) the last value from the given stack index
    ///
    /// Complexity: _O(n) _ where _n_ is the internal capacity of the `MultiStack`
    ///
    /// - Parameters:
    ///   - stack: index (1 based) indicating the stack from which to pop the value
    ///
    /// - Throws:
    ///   - `stackIndexOutOfBounds` if `stack` is more than the number of supported stacks configured a `init`
    ///
    /// - Returns: The value of the last element of the given stack or `nil` if the stack doesn't have any values
    public mutating func pop(fromStack stack: Int) throws -> V? {
        try validateStackIndex(stack)
        var index = stack - 1
        while index < capacity, arr[index] != nil {
            if arr[index] != nil {
                index += numberOfStacks
            }
            if arr[index] == nil {
                let value = arr[index - numberOfStacks]
                arr[index - numberOfStacks] = nil
                return value
            }
        }
        return nil
    }

    /// returns the last value from the given stack index without removing it from the stack
    ///
    /// Complexity: _O(n) _ where _n_ is the internal capacity of the `MultiStack`
    ///
    /// - Parameters:
    ///   - stack: index (1 based) indicating the stack from which to peek the value
    ///
    /// - Throws:
    ///   - `stackIndexOutOfBounds` if `stack` is more than the number of supported stacks configured a `init`
    ///
    /// - Returns: The value of the last element of the given stack or `nil` if the stack doesn't have any values
    public func peek(atStack stack: Int) throws -> V? {
        try validateStackIndex(stack)
        var index = stack - 1
        var returnCandidate: V?
        while index < arr.count, arr[index] != nil {
            if arr[index] != nil {
                returnCandidate = arr[index]
                index += numberOfStacks
                
            }
            if index >= arr.count {
                // reached last element in the array for the stack
                return returnCandidate
            }
            if arr[index] == nil {
                return returnCandidate
            }
        }
        return arr[index]
    }

    private func validateStackIndex(_ stack: Int) throws {
        if stack > numberOfStacks || stack < 1 {
            throw MultiStacksError.stackIndexOutOfBounds
        }
    }
}

/// Sample usage
var stack = MultiStacks<Int>(numberOfStacks: 3, capacity: 10)
do {
    try stack.insert(value: 1, intoStack: 1)
    try stack.insert(value: 2, intoStack: 1)
    try stack.insert(value: 3, intoStack: 1)
    try stack.insert(value: 4, intoStack: 1)
    try? stack.insert(value: 5, intoStack: 1) // throws `stackOutOfCapacity`

    try stack.insert(value: 1, intoStack: 2)
    try stack.insert(value: 2, intoStack: 2)

    try stack.insert(value: 1, intoStack: 3)

    let val1 = try stack.pop(fromStack: 2) // 2
    let val2 = try stack.pop(fromStack: 2) // 1
    let val3 = try stack.pop(fromStack: 2) // nil
    
    print(stack.arr)
    print(String(describing: try stack.peek(atStack: 1))) // 4
    print(String(describing:try stack.peek(atStack: 2))) // nil
    print(String(describing:try stack.peek(atStack: 3))) // 1
}
catch {
    print(error)
}


