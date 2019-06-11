//
//  WeakCollection.swift
//  WeakCollection
//
//  Created by Sabatie Guillaume on 6/11/19.
//
import Foundation

struct  WeakWrapper {
    private(set) weak var value: AnyObject?
    
    init(_ value: AnyObject) {
        self.value = value
    }
}

public class WeakCollection<T>: Sequence, IteratorProtocol {
    public typealias Element = T
    
    private var weakReferences: [WeakWrapper] = [WeakWrapper]()
    private var  currentindex: Int = 0
    
    public var references: [WeakCollection.Element] { return weakReferences.compactMap({return $0.value as? T})}
    public var count: Int { return weakReferences.count }
    
    
    public init() {}
    
    public func add(_ object: T) {
        removeNil()
        guard
            weakReferences.filter({ (reference: WeakWrapper) -> Bool in
                let refValue = reference.value as AnyObject
                let refObject = object as AnyObject
            
                return refValue === refObject
            }).count == 0
        else {
            return
        }
        
        self.weakReferences.append(WeakWrapper(object as AnyObject))
    }
    
    @discardableResult public  func remove(delegate: T) -> T?{
        removeNil()
        guard
            let index = weakReferences.firstIndex(where: { ($0.value as AnyObject) === (delegate as AnyObject)})
        else {
            return nil
        }
        return self.weakReferences.remove(at: index).value as? T
    }
    
    fileprivate  func removeNil() {
        while let index = weakReferences.firstIndex(where: { $0.value == nil }) {
            weakReferences.remove(at: index)
            if index < self.currentindex {
                currentindex -= 1
            }
        }
        weakReferences.enumerated().forEach { (offset: Int, element: WeakWrapper) in
            if element.value == nil {
                self.weakReferences.remove(at: offset)
            }
        }
    }
    
    public func execute(_ closure: ((_ object: T) throws -> Void)) rethrows {
        removeNil()
        try weakReferences.reversed().forEach({ (weakReference) in
            guard let reference = weakReference.value as? T else { return }
            try closure(reference)
        })
        
    }
    
    public func next() -> T? {
        removeNil()
        
        guard self.count > 0 && currentindex < count else { return nil }
        let reference = references[currentindex]
        currentindex += 1
        return reference
    }
    
}

