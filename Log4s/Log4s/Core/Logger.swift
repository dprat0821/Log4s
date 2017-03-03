//
//  Logger.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation



public func logger(_ name:String = "") -> Logger {
    return Logger.inst(name)
}



final public class Logger{
    
    //
    // MARK: - Instances
    //
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
    
    init() {
        reset()
    }
    
    //
    // MARK: - Severities
    //
    public var appendersSev: Severity {
        get{
            var sev = Severity.off
            for appender in appenders{
                if appender.maxSeverity.rawValue > sev.rawValue{
                    sev = appender.maxSeverity
                }
            }
            return sev
        }
    }
    public var maxSeverity : Severity = .verbose
    
    
    
    //
    // MARK: - Appenders & AppenderListener
    //
    private var appenders = [Appender]()
    
    @discardableResult public func add(appender:Appender) -> Logger {
        if isUsingDefaultConfiguration{
            appenders.removeAll()
            isUsingDefaultConfiguration = false
        }
        appenders.append(appender)
        return self
    }
    
    //
    // MARK: - Wildcard Layout
    //
    
    public var layout:Layout?{
        set{
            if let newVal = newValue{
                for a in appenders{
                    a.layout = newVal
                }
            }
        }
        get{
            var r:Layout? = nil
            for a in appenders{
                if r == nil{
                    r = a.layout
                }
                else{
                    if r !== a.layout{
                        return nil
                    }
                }
            }
            return r
        }
    }
    
    //
    // MARK: - Logging
    //
    private(set) var numEvents: UInt = 0
    
    func log(_ event: Event){
        for a in self.appenders {
            a._dump(event){error in}
        }
        numEvents += 1
    }
    
    
    
    public func log(_ message: String, severity: Severity = .info, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line) {
        if appendersSev.rawValue >= severity.rawValue {
            let event = Event(id: numEvents,sev: severity, tags: tags, message: message, file: file, method: method, line: line)
            log(event)
        }
    }
    
    static public func info(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line){
        logger().log(message, severity: .info, tags: tags,file:file, method:method, line:line)
    }
    
    static public func debug(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line){
        logger().log(message, severity: .debug, tags: tags,file:file, method:method, line:line)
    }
    
    static public func error(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line){
        logger().log(message, severity: .error, tags: tags,file:file, method:method, line:line)
    }
    
    static public func warn(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line){
        logger().log(message, severity: .warn, tags: tags,file:file, method:method, line:line)
    }
    
    static public func fatal(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line){
        logger().log(message, severity: .fatal, tags: tags,file:file, method:method, line:line)
    }
    
    static public func verbose(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line){
        logger().log(message, severity: .verbose, tags: tags,file:file, method:method, line:line)
    }
    
    //
    // MARK: - Reset & Default
    //
    public internal(set) var isUsingDefaultConfiguration = true
    
    
    
    @discardableResult public func reset() -> Logger{
        appenders.removeAll()
        add(appender: AppenderConsole().reset())
        
        maxSeverity = .verbose
        isUsingDefaultConfiguration = true
        return self
    }

}



