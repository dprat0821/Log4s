//
//  AppenderPersistent.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-27.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation

let defaultPath = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]

public class AppenderPersistent: Appender{
    var path:URL
    
    override public func dump(_ event: Event, completion: @escaping (Error?)-> Void){
        print(event.message)
        
        completion(nil)
    }
    init?(locatedAt path:URL = defaultPath) {
        self.path = path
        super.init()
    }
    
}
