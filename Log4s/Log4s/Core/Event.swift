//
//  Event.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public class Loggable<IdType> {
    var id: IdType
    var payload: [String:AnyObject]?
    init(_ id: IdType) {
        self.id = id
    }
    public func add(_ detail: AnyObject, for key: String) {
        if self.payload == nil {
            self.payload = [String:AnyObject]()
        }
        self.payload?[key] = detail
    }
    
    public func copy() -> Loggable<IdType>{
        let r = Loggable<IdType>(id)
        r.payload = self.payload
        return r
    }
}

public class Event: Loggable<UInt>{
    public var sev: Severity
    public var tags: [String]?
    public var message: String
    public var file: String
    public var method: String
    public var line: UInt
    public var object: AnyObject?
    public var timestamp: Date
    
    init(id:UInt,sev:Severity, tags:[String]?, message: String, file: String, method: String, line: UInt) {
        self.sev = sev
        self.tags = tags
        self.message = message
        self.file = file
        self.method = method
        self.line = line
        self.timestamp = Date()
        super.init(id)
    }
    
    override public func copy() -> Event {
        let r = Event(id: id, sev: sev, tags: tags, message: message, file: file, method: method, line: line)
        r.payload = payload
        return r
    }
}

