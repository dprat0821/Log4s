//
//  Error.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation

let defaultErrorDomain = "Log4s"

extension NSError{
    static func make(domain:String = defaultErrorDomain, code:Int, desp:String) -> NSError{
        return NSError(domain: domain, code: code, userInfo: ["NSLocalizedDescriptionKey" : desp])
    }
}

//class Error {
//}
