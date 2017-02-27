//
//  AppenderJSONFile.swift
//  SampleSwiftIOS
//
//  Created by Daniel Pan on 25/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation
import Log4s
/**
 AppenderJSONFile will
 */

let defaultSizePerFile = 1000

class AppenderPersistent: Appender{
    var buffer: String?
    var size: Int = defaultSizePerFile

    override func dump(_ event: Event, completion: @escaping (Error?)->Void){
        print(event.message)
        completion(nil)
    }
}
