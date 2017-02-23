//
//  IOJSON.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


class JSONInputter : Inputter{
    func read(path:URL, completion:InputCompletion) {
        do{
            let data = try Data(contentsOf: path)
            read(data: data, completion: completion)
        }catch{
            completion(nil, error)
        }
    }
    
    func read(string:String,completion:InputCompletion){
        guard let data = string.data(using: String.Encoding.utf8) else {
            completion(nil, IOError.encodeFailure(method: "UTF8"))
            return
        }
        read(data:data, completion: completion)
    }
    
    func read(data:Data,completion:InputCompletion){
        do{
            guard let obj = try JSONSerialization.jsonObject(with: data as Data, options: []) as? IODict else {
                completion(nil, IOError.invalidFormat(path: String(describing: data), format: "JSON"))
                return
            }
            completion(obj,nil)
        }catch{
            completion(nil, error)
        }
        
    }
}

class JSONOutputter : Outputter{
    
    func write(source: IOValue, toString completion: (String) -> ()) {
        
    }
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
