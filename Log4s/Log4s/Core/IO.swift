//
//  IO.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public typealias IOValue = AnyObject
public typealias IODict = [String:IOValue]
public typealias IOArray = [IOValue]
public typealias InputCompletion = (IODict?) -> ()



enum IOError: Error {
    case fileNotExists(path:String)
    case failedToLoad(path:String)
    case invalidFormat(path:String, format:String)
    case encodeFailure(method:String)
}



public protocol Reader {
    func read(fromFile path:String, completion:InputCompletion) throws
    func read(fromString string:String,completion:InputCompletion) throws
    func read(fromData data:Data,completion:InputCompletion) throws
}




public protocol Writer {
    func write(source:IOValue,toString completion: (String)->()) throws
}
