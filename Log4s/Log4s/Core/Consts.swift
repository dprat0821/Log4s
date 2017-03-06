//
//  Consts.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public struct Severity :  Equatable, Hashable, Comparable, CustomStringConvertible, CustomDebugStringConvertible{
    public typealias RawValue = Int
    public var rawValue: Int
    public var desp: String
    
    public static let off =        Severity(rawValue: 0, desp: "off")
    public static let fatal =      Severity(rawValue: 100, desp: "fatal")
    public static let error =      Severity(rawValue: 200, desp: "error")
    public static let warn =       Severity(rawValue: 300, desp: "warn")
    public static let info =       Severity(rawValue: 400, desp: "info")
    public static let debug =      Severity(rawValue: 500, desp: "debug")
    public static let verbose =    Severity(rawValue: 600, desp: "verbose")
    
    
    public var hashValue: Int{
        return rawValue
    }
    
    public var description: String { get{return desp} }
    public var debugDescription: String { get{return desp} }
    
    public static func < (lhs:Severity,rhs:Severity) -> Bool{
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func ==(lhs: Severity, rhs: Severity) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public init(rawValue: Severity.RawValue, desp: String){
        self.rawValue = rawValue
        self.desp = desp
    }
}

//open enum Severity: Int {
//    case off = 0
//    case fatal = 100
//    case error = 200
//    case warn = 300
//    case info = 400
//    case debug = 500
//    case verbose = 600
//    
//}

public typealias Tag = String

public enum Case {
    case upper
    case lower
    case normal
}

extension String{
    func using(_ letterCase: Case) -> String {
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
