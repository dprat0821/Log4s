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
public typealias InputCompletion = (IODict?,Error?) -> ()



enum IOError: Error {
    case fileNotExists(path:String)
    case failedToLoad(path:String)
    case invalidFormat(path:String, format:String)
    case encodeFailure(method:String)
}



public protocol Inputter {
    func read(path:URL, completion:InputCompletion)
    func read(string:String,completion:InputCompletion)
    func read(data:Data,completion:InputCompletion)
}




public protocol Outputter {
    func write(source:IOValue,toString completion: (String)->())
}
