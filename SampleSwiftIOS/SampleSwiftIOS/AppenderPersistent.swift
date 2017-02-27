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

let defaultSizePerFile = 1000   //In unit of bytes

class AppenderPersistent: Appender{
    var buffer: String?
    var size: Int

    init(size: Int = defaultSizePerFile) {
        self.size = size
    }
    
    
    override func dump(_ event: Event, completion: @escaping (Error?)->Void){
        buffer += "\n" + event.message
        if buffer?.characters.count >= size {
            
        }
        completion(nil)
    }
}
