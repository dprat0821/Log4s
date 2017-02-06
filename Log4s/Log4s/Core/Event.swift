//
//  Event.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation



public class Event{
    public var id: UInt
    public var sev: Severity
    public var tags: [String]?
    public var message: String
    public var file: String
    public var method: String
    public var line: UInt
    public var object: AnyObject?
    public var timestamp: Date
    var details: [String:AnyObject]?
    
    init(id:UInt,sev:Severity, tags:[String]? = nil, message: String, file: String, method: String, line: UInt) {
        self.id = id
        self.sev = sev
        self.tags = tags
        self.message = message
        self.file = file
        self.method = method
        self.line = line
        self.timestamp = Date()
    }
    
    public func copy() -> Event {
        let r = Event(id: id, sev: sev, tags: tags, message: message, file: file, method: method, line: line)
        r.details = details
        return r
    }
    
    public func add(_ detail: AnyObject, for key: String) {
        if self.details == nil {
            self.details = [String:AnyObject]()
        }
        self.details?[key] = detail
    }
    
    public func detail(_ key: String) -> AnyObject? {
        if let details = details{
            return details[key]
        }
        else{
            return nil
        }
    }
}

