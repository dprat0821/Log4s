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
public typealias severtiy = LayoutSeverity
public class LayoutSeverity: Layout {
    override public func present(_ event:Event) -> String {
        return String(describing: event.sev).use(letterCase)
    }

//    @discardableResult public func uppercased()  -> LayoutSeverity {
//        self.letterCase = .upper
//        return self
//    }
//    
//    @discardableResult public func lowercased()  -> LayoutSeverity {
//        self.letterCase = .lower
//        return self
//    }
}

//
// MARK: LayoutTags
//
public typealias tags = LayoutTags
let defaultTagDivider = "|"
public class LayoutTags: Layout{
    public var delimiter: String
//    public var letterCase: Case = .normal
    override public func present(_ event:Event) -> String {
        if let joinedString = event.tags?.joined(separator: delimiter){
            return joinedString.use(letterCase)
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
//    public var letterCase: Case
    override public func present(_ event:Event) -> String {
        return event.message
    }
    
//    @discardableResult public func use(_ letterCase: Case)  -> Layout {
//        self.letterCase = letterCase
//        return self
//    }

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





