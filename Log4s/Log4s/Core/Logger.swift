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
    
    
    static func inst(_ name: String = "") -> Logger{
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
    
    static public var appendersSev: Severity {return logger().appendersSev}
    
    public var maxSeverity : Severity = .verbose
    static public var maxSeverity: Severity{
        get{return logger().maxSeverity}
        set{logger().maxSeverity = newValue}
    }
    
    @discardableResult public func use(maxSev: Severity) -> Logger {
        self.maxSeverity = maxSev
        return self
    }
    
    @discardableResult static public func use(maxSev: Severity) -> Logger {
        return logger().use(maxSev: maxSev)
    }
    
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
    @discardableResult static public func add(appender:Appender) -> Logger{
        return logger().add(appender: appender)
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
    
    static public var layout:Layout?{
        set{logger().layout = newValue}
        get{return logger().layout}
    }
    
    @discardableResult public func use(layout:Layoutable) -> Logger {
        self.layout = layout.asLayout()
        return self
    }
    
    @discardableResult static public func use(layout:Layoutable) -> Logger {
        return logger().use(layout: layout)
    }
    
    @discardableResult public func use(layout:[Layoutable],dividedBy delimiter:String = defaultChainDelimiter) -> Logger {
        self.layout = Layout.chain(layout)
        return self
    }
    
    @discardableResult static public func use(layout:[Layoutable],dividedBy delimiter:String = defaultChainDelimiter) -> Logger {
        return logger().use(layout: layout,dividedBy: delimiter )
    }
    
    
    
    //
    // MARK: - Logging
    //
    private(set) var numEvents: UInt = 0
    

    
    //
    // MARK: -- Basic logging
    //
    @discardableResult func log(_ event: Event) -> Logger{
        for a in self.appenders {
            a._dump(event){error in}
        }
        numEvents += 1
        return self
    }
    
    
    @discardableResult public func log(_ message: String, severity: Severity = .info, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger {
        if self.maxSeverity >= severity && appendersSev >= severity {
            let event = Event(id: numEvents,sev: severity, tags: tags, message: message, file: file, method: method, line: line)
            log(event)
        }
        return self
    }
    
    @discardableResult public func log(_ error:Error, severity:Severity = .error, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        log(error.localizedDescription, severity: severity, tags: tags, file:file, method:method, line:line)
        return self
    }
    
    @discardableResult public func log(_ any:Any, severity:Severity = .info, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        log(String(describing: any), severity: severity, tags: tags, file:file, method:method, line:line)
        return self
    }
    
    //
    // MARK: -- Logging Shortcuts with severity levels
    //
    
    @discardableResult public func info(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .info, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult public func debug(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .debug, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult public func error(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .error, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult public func warn(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .warn, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult public func fatal(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .fatal, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult public func verbose(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .verbose, tags: tags,file:file, method:method, line:line)
    }
    
    
    //
    // MARK: -- Static Logging Methods
    //

    @discardableResult static public func log(_ error: Error,severity: Severity = .error, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(error, severity: severity, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult static public func log(_ any: Any,severity: Severity = .info, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(any, severity: severity, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult static public func log(_ message: String,severity: Severity = .info, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: severity, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult static public func info(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .info, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult static public func debug(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .debug, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult static public func error(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .error, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult static public func warn(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .warn, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult static public func fatal(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .fatal, tags: tags,file:file, method:method, line:line)
    }
    
    @discardableResult static public func verbose(_ message: String, tags: [String]? = nil , file: String = #file, method: String = #function, line: UInt = #line)-> Logger{
        return logger().log(message, severity: .verbose, tags: tags,file:file, method:method, line:line)
    }
    
    //
    // MARK: - Reset & Default
    //
    public internal(set) var isUsingDefaultConfiguration = true
    static public var isUsingDefaultConfiguration: Bool{
        get{return logger().isUsingDefaultConfiguration}
    }
    
    
    @discardableResult public func reset() -> Logger{
        appenders.removeAll()
        add(appender: AppenderConsole().reset())
        
        maxSeverity = .verbose
        isUsingDefaultConfiguration = true
        return self
    }
    
    @discardableResult static public func reset() -> Logger {
        return logger().reset()
    }

}



