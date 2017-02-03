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
    
    override func modify(loggable:Loggable<Any>, completion: @escaping LayoutCompletion ) throws {
        
        let time = formatter.string(from: loggable.timestamp)
        loggable.message = "\(time) \(loggable.message)"
        try completion(loggable)
    }
    
    public init(_ format: String = defaultTimeFormat) {
        self.formatter.dateFormat = format
    }
}
