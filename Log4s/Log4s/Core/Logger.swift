//
//  Logger.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


func logger(_ name:String = "") -> Logger {
    return Logger.inst(name)
}

public class Logger{
    static private var _default = Logger()
    static private var dict = [String:Logger]()
    
    static public func inst(_ name: String = "") -> Logger{
        if name == "" {
            return _default
        }
        else{
            if let l = dict[name]{
                return l
            }
            else{
                let newLogger = Logger()
                dict[name] = newLogger
                return newLogger
            }
        }
    }
    
    public var maxSev = Severity.verbose
    
    var appenders = [Appender]()
    


}

