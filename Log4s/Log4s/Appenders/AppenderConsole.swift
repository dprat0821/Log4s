//
//  AppenderConsole.swift
//  Log4s
//
//  Created by Daniel Pan on 25/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public class AppenderConsole: Appender {
    override public func dump(_ event: Event, completion: @escaping (Error?)-> Void){
        print(event.message)
        completion(nil)
    }
    public override init() {
        super.init()
    }
}
