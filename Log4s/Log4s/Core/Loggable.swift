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
}

public class Event<IdType>: Loggable<Any>{
    public var sev: Severity
    public var tags: [String]?
    public var message: String
    public var file: String
    public var method: String
    public var line: UInt
    public var object: AnyObject?
    public var timestamp: NSDate
    
    init(id:UInt,sev:Severity, detail:UInt, tags:[String]?, message: String, file: String, method: String, line: UInt) {
        self.sev = sev
        self.tags = tags
        self.message = message
        self.file = file
        self.method = method
        self.line = line
        self.timestamp = NSDate()
        super.init(id)
    }
}

