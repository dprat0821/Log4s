//
//  IOPlist.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


class PlistInputter {
    
    func read(from path:URL, completion: @escaping InputCompletion){
        do{
            let data = try Data(contentsOf: path)
            read(from:data, completion: completion)
        }catch{
            completion(nil, error)
        }
    }
    func read(from string:String,  completion: @escaping InputCompletion){
        
    }
    func read(from data:Data,completion: @escaping InputCompletion){
        completion(nil, nil)
    }
}
