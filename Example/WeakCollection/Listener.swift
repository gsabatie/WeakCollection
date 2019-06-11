//
//  Listener.swift
//  WeakCollection_Example
//
//  Created by Sabatie Guillaume on 6/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

final class Listener {
    
}

extension Listener: AppDelegateStatus {
    func didLoad() {
        print("app loaded")
    }
}
