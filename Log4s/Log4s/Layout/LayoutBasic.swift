//
//  LayoutBasic.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-03.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


let defaultTimeFormat = "yy/MM/dd HH:mm:ss"

public class LayoutTime: Layout {
    let formatter = DateFormatter()
    
    override public func modify(_ event:Event) -> Event {
        let time = formatter.string(from: event.timestamp)
        event.message = "\(time) \(event.message)"
        return event
    }
    
    public init(_ format: String = defaultTimeFormat) {
        self.formatter.dateFormat = format
    }
}


open enum TypeLayoutDelimiter{
    case 
}

public class LayoutDelimiter: Layout {
    override public func modify(_ event:Event) -> Event {
        let time = formatter.string(from: event.timestamp)
        event.message = "\(time) \(event.message)"
        return event
    }
    
}
