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
    func read(from path:URL, completion: @escaping InputCompletion)
    func read(from string:String,  completion: @escaping InputCompletion)
    func read(from data:Data,completion: @escaping InputCompletion)
}


public protocol Outputter {
    func write(stringFrom source:IOValue,completion: @escaping (String?,Error?)->())
}
