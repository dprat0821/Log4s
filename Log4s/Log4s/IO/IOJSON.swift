//
//  IOJSON.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


class JSONInputter: Inputting {
    func input(file name:String, completion:InputCompletion) throws {
        
        //Finish this method later...
    }
    
    func input(string:String,completion:InputCompletion) throws{
        guard let data = string.data(using: String.Encoding.utf8) else {
            throw IOError.encodeFailure(method: "UTF8")
        }
        do{
            try input(data:data, completion: completion)
        }catch{
            throw error
        }
    }
    
    func input(data:Data,completion:InputCompletion) throws{
        
        guard let obj = try JSONSerialization.jsonObject(with: data as Data, options: []) as? IODict else {
            throw IOError.invalidFormat(path: String(describing: data), format: "JSON")
        }
        completion(obj)
    }
}

class JSONOutputter: Outputting {
    func outputString(source:IOValue,completion: (String)->()) throws{
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: source, options: JSONSerialization.WritingOptions())
            let r = String(data:jsonData,encoding: String.Encoding.utf8)
            if let r = r {
                completion(r)
            }
            else{
                
                throw IOError.encodeFailure(method: "UTF8")
                
            }
            
        }catch{
            throw error
        }
    }
}
