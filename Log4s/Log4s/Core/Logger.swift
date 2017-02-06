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
    
    //
    // MARK: - Severities
    //
    public private(set) var appendersSev = Severity.verbose
    public var maxSeverity : Severity = .verbose {
        didSet {
            syncAppendersSeverity()
        }
    }
    
    
    /**
     
     */
    private func syncAppendersSeverity() {
        var sev = Severity.off
        for appender in appenders{
            if appender.maxSeverity.rawValue > sev.rawValue{
                sev = appender.maxSeverity
            }
        }
        appendersSev = sev
    }
    
    
    
    
    //
    // MARK: - Appenders & AppenderListener
    //
    private var appenders = [Appender]()
    
    
    
    public func add(appender:Appender) -> Logger {
        appenders.append(appender)
        NotificationCenter.default.addObserver(forName: nameSetSeverity, object: appender, queue: nil){ notification in
            self.syncAppendersSeverity()
        }
        syncAppendersSeverity()
        return self
    }
    
    
    
    //
    // MARK: - Logging
    //
    public private(set) var numEvents: UInt = 0
    
    public func log(event: Event){
        for a in appenders {
            a._dump(event)
        }
    }
    
    
    public func log(_ severity: Severity, tags: [String]? = nil, message: String, file: String = #file, method: String = #function, line: UInt = #line) {
        if appendersSev.rawValue >= severity.rawValue {
            let event = Event(id: numEvents,sev: severity, tags: tags, message: message, file: file, method: method, line: line)
            
            for a in self.appenders {
                a.dump(event)
            }
            numEvents += 1
        }
        
        
    }
    
    //
    // MARK: - Reset & Default
    //
    public func resetAppenders(){
        NotificationCenter.default.removeObserver(self, name: nameSetSeverity, object: nil)
        appenders.removeAll()
        appendersSev = .off
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: nameSetSeverity, object: nil)
    }
    
    public func reset(){
        resetAppenders()
        maxSeverity = .verbose
        
    }

}

