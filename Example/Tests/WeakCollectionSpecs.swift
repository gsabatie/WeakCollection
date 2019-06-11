//
//  WeakCollectionSpecs.swift
//  WeakCollection_Tests
//
//  Created by Sabatie Guillaume on 6/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

import XCTest
import Quick
import Nimble

import WeakCollection

@testable import Pods_WeakCollection_Example

protocol MockPrtotocol {
    func afunc()
}

class TestClass: MockPrtotocol {
    var aFuncCalledTimes = 0
    
    func afunc() {
        aFuncCalledTimes += 1
    }
    
    
}


final class WeakCollectionSpecs: QuickSpec {
    
    var typicalWeakCollection: WeakCollection<MockPrtotocol>!
    
    func setup() {
        self.typicalWeakCollection = WeakCollection<MockPrtotocol>()
    }
    
    override func spec() {
        
        beforeEach {
            self.setup()
        }
        describe("Add") {

            context("empty") {
                let aRef = TestClass()
                beforeEach {
                    self.typicalWeakCollection = WeakCollection<MockPrtotocol>()
                    self.typicalWeakCollection.add(aRef)
                }
                it("should add reference") {
                    expect(self.typicalWeakCollection.count) == 1
                    expect(self.typicalWeakCollection.references[0]) === aRef
                }
            }
            
            context("populated") {
                
                let aRef1 = TestClass()
                let aRef2 = TestClass()
                
                beforeEach {
                    self.typicalWeakCollection = WeakCollection<MockPrtotocol>()
                    self.typicalWeakCollection.add(aRef1)
                    self.typicalWeakCollection.add(aRef2)
                }
                it("should add reference") {
                    expect(self.typicalWeakCollection.count) == 2
                    expect(self.typicalWeakCollection.references[0]) === aRef1
                    expect(self.typicalWeakCollection.references[1]) === aRef2
                }
                
                context("with same item") {
                    
                    beforeEach {
                        self.typicalWeakCollection = WeakCollection<MockPrtotocol>()
                        self.typicalWeakCollection.add(aRef1)
                        self.typicalWeakCollection.add(aRef1)
                    }
                    it("should not add reference") {
                        expect(self.typicalWeakCollection.count) == 1
                        expect(self.typicalWeakCollection.references[0]) === aRef1
                    }
                }
            }
        }
        
        describe("remove") {
            
            context("populated") {
            
                let aRef1 = TestClass()
                let aRef2 = TestClass()
                
                beforeEach {
                    self.typicalWeakCollection = WeakCollection<MockPrtotocol>()
                    self.typicalWeakCollection.add(aRef1)
                    self.typicalWeakCollection.add(aRef2)
                    self.typicalWeakCollection.remove(delegate: aRef1)
                }
                it("should remove reference") {
                    expect(self.typicalWeakCollection.count) == 1
                    expect(self.typicalWeakCollection.references[0]) === aRef2
                }
                
                context("inexistant items") {
                    beforeEach {
                        self.typicalWeakCollection = WeakCollection<MockPrtotocol>()
                        self.typicalWeakCollection.add(aRef1)
                        self.typicalWeakCollection.remove(delegate: aRef2)
                    }
                    it("should not remove") {
                        expect(self.typicalWeakCollection.count) == 1
                        expect(self.typicalWeakCollection.references[0]) === aRef1
                    }
                }
            }
        }
        
        describe("execute") {
            
            let aRef1 = TestClass()
            let aRef2 = TestClass()
            
            beforeEach {
                self.typicalWeakCollection = WeakCollection<MockPrtotocol>()
                self.typicalWeakCollection.add(aRef1)
                self.typicalWeakCollection.add(aRef2)
                
                expect(aRef1.aFuncCalledTimes) == 0
                expect(aRef2.aFuncCalledTimes) == 0
                
                self.typicalWeakCollection.execute({ (ref: MockPrtotocol) in
                    ref.afunc()
                })
            }
            it("should call all reference's method") {
                expect(aRef1.aFuncCalledTimes) == 1
                expect(aRef2.aFuncCalledTimes) == 1
            }
        }
    }
    
}
