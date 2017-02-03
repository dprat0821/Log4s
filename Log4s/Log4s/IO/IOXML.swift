//
//  IOXML.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


class XMLInputter {
    func input(file name:String, completion:InputCompletion) throws {
        guard let path = Bundle.main.path(forResource: name, ofType: "xml") else {
            throw IOError.fileNotExists(path: name)
        }

        guard let data = NSData(contentsOfFile: path) else {
            throw IOError.failedToLoad(path: path)
        }
        do{
            //try input(data as Data, completion: completion)
        }catch{
            throw error
        }
    }
    
    func input(string:String,completion:InputCompletion) throws{

    }
    
    func input(data:Data,completion:InputCompletion) throws{
        
        guard let obj = try JSONSerialization.jsonObject(with: data as Data, options: []) as? IODict else {
            throw IOError.invalidFormat(path: String(describing: data), format: "JSON")
        }
        completion(obj)
    }
}
