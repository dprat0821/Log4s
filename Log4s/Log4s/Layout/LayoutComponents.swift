//
//  LayoutBasic.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-03.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


//
// MARK: LayoutId
//
public typealias id = LayoutId
public class LayoutId:Layout {
    override public func present(_ event:Event) -> String {
        return String(event.id)
    }
}

//
// MARK: LayoutTime
//

public typealias dateTime = LayoutTime
let defaultTimeFormat = "yy/MM/dd HH:mm:ss"
public class LayoutTime: Layout {
    let formatter = DateFormatter()
    
    override public func present(_ event:Event) -> String {
        return formatter.string(from: event.timestamp)
    }
    
    public init(_ format: String = defaultTimeFormat) {
        self.formatter.dateFormat = format
    }
}




//
// MARK: LayoutSeverity
//
public typealias severity = LayoutSeverity
public class LayoutSeverity: Layout {
    override public func present(_ event:Event) -> String {
        return String(describing: event.sev).using(letterCase)
    }
    public init(){
        super.init()
        letterCase = .upper
    }
}

//
// MARK: LayoutTags
//
public typealias tags = LayoutTags
let defaultTagDivider = "|"
public class LayoutTags: Layout{
    public var delimiter: String
    override public func present(_ event:Event) -> String {
        if let joinedString = event.tags?.joined(separator: delimiter){
            return joinedString.using(letterCase)
        }
        else{
            return ""
        }
    }
    init(dividedBy:String = defaultTagDivider) {
        self.delimiter = dividedBy
    }
    @discardableResult public func dividedBy(by delimiter: String) -> Layout{
        self.delimiter = delimiter
        return self
    }

}


//
// MARK: LayoutMessage
//
public typealias message = LayoutMessage
public class LayoutMessage: Layout {
    override public func present(_ event:Event) -> String {
        return event.message.using(letterCase)
    }
}


extension Layout{
    public static func id() -> LayoutId{
        return LayoutId()
    }
    
    public static func time(_ format:String = defaultTimeFormat) -> LayoutTime{
        return LayoutTime(format)
    }
    
    public static func severity() -> LayoutSeverity {
        return LayoutSeverity()
    }
    
    public static func tags(dividedBy: String = defaultTagDivider) -> LayoutTags{
        return LayoutTags(dividedBy: dividedBy)
    }
    public static func message() -> LayoutMessage {
        return LayoutMessage()
    }
}





