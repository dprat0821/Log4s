//
//  LayoutDelimiter.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-08.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


//
// MARK: LayoutDelimiter
//

public typealias delimiter = LayoutDelimiter
public enum Delimiter{
    case space
    case spaces(Int)
    case pipe
    case tab
    case tabs(Int)
    case breakline
    case custom(String)
    case customRepeat(String, Int)
    
    public var raw:String{
        switch self {
        case .space:            return " "
        case .spaces(let num):   return String.init(repeating: " ", count: num)
        case .pipe:             return " | "
        case .tab:              return "\t"
        case .tabs(let num):    return String.init(repeating: "\t", count: num)
        case .breakline:        return "\n"
        case .custom(let str):  return str
        case .customRepeat(let str, let num): return String.init(repeating: str, count: num)
        }
    }
}


public extension String{
    func asLayout(times num: Int = 1) -> LayoutDelimiter {
        return LayoutDelimiter.init(self, count: num)
    }
}

public class LayoutDelimiter: Layout {
    let type: Delimiter
    override public func present(_ event:Event) -> String {
        return type.raw
    }
    public init(_ type: Delimiter){
        self.type = type
    }
    
    public init(_ symbol: String, count times: Int = 1) {
        type = .customRepeat(symbol, times)
    }
    
    public static func space(_ num:Int = 1) -> LayoutDelimiter{
        if num == 1{
            return LayoutDelimiter(.space)
        }
        else{
            return LayoutDelimiter(.spaces(num))
        }
    }
    public static func pipe() -> LayoutDelimiter{
        return LayoutDelimiter(.pipe)
    }
    
    public static func symbol(_ str:String, repeat times:Int = 1) -> LayoutDelimiter {
        if times == 1{
            return LayoutDelimiter(.custom(str))
        }
        else{
            return LayoutDelimiter(.customRepeat(str, times))
        }
    }
    public static func tab(times:Int = 1)-> LayoutDelimiter{
        if times == 1{
            return LayoutDelimiter(.tab)
        }
        else{
            return LayoutDelimiter(.tabs(times))
        }
    }
    public static func breakline() -> LayoutDelimiter{return LayoutDelimiter(.breakline)}
    
}

extension Layout{
    public static func space(times: Int) -> LayoutDelimiter{
        return LayoutDelimiter.space(times)
    }
    public static func pipe() -> 
}



