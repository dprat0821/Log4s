//
//  IO.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public typealias IOValue = Any
public typealias IODict = [String:IOValue]
public typealias IOArray = [IOValue]
public typealias InputCompletion = (IOValue?,Error?) -> ()



extension LogError{
    static func failedToLoad(path:String) -> LogError {return LogError(101).desp("Failed to read the file (\(path))")}
    static func invalid(path:String, decodedAs format:String) -> LogError {return LogError(102).desp("Failed to decode (\(path)) to \(format)")}
    
}


public protocol Inputter {
    func read(from path:URL, completion: @escaping InputCompletion)
    func read(from string:String,  completion: @escaping InputCompletion)
    func read(from data:Data,completion: @escaping InputCompletion)
}


public protocol Outputter {
    func write(stringFrom source:IOValue,completion: @escaping (String?,Error?)->())
}
