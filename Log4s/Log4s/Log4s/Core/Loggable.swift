//
//  Event.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public protocol Loggable {
    <#requirements#>
}

public class Event{
    public var id: Indexable
    public var sev: Severity
    public var tags: [String]?
    public var body: Any
    public var file: String
    public var method: String
    public var line: UInt
    public var object: AnyObject?
    public var timestamp: NSDate
    
}

