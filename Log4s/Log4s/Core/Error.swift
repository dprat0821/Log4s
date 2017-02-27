//
//  Error.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation

let defaultErrorDomain = "Log4s"

let LocalizedDescriptionKey = "NSLocalizedDescriptionKey"

class LogError: NSError{
    var _localizedDescription : String?
    
    override public var localizedDescription: String {
        get{
            if let _localizedDescription = _localizedDescription{
                return _localizedDescription
            }
            else{
                return "Operation cannot be finished"
            }
        }
    }
    
    init(_ code: Int, domain: String = defaultErrorDomain) {
        super.init(domain: domain, code: code, userInfo: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult func desp(_ string:String) -> LogError {
        _localizedDescription = string
        return self
    }
    
}



