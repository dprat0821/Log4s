//
//  Consts.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public enum Severity: Int {
    case off = 0
    case fatal = 100
    case error = 200
    case warn = 300
    case info = 400
    case debug = 500
    case verbose = 600
    
}

public typealias Tag = String

public enum Case {
    case upper
    case lower
    case normal
}

extension String{
    func to(_ letterCase: Case) -> String {
        switch letterCase {
        case .upper:
            return uppercased()
        case .lower:
            return lowercased()
        case .normal:
            return self
        }
    }
}
