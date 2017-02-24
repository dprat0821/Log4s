//
//  IOJSON.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


class JSONInputter : Inputter{
    func read(from path:URL, completion:@escaping InputCompletion) {
        do{
            let data = try Data(contentsOf: path)
            read(from:data, completion: completion)
        }catch{
            completion(nil, error)
        }
    }
    
    func read(from string:String,completion:@escaping InputCompletion){
        guard let data = string.data(using: String.Encoding.utf8) else {
            completion(nil, IOError.encodeFailure(method: "UTF8"))
            return
        }
        read(from:data, completion: completion)
    }
    
    func read(from data:Data,completion:@escaping InputCompletion){
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
    
    func write(stringFrom source:IOValue,completion: @escaping (String?,Error?)->()){
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: source, options: JSONSerialization.WritingOptions())
            let r = String(data:jsonData,encoding: String.Encoding.utf8)
            if let r = r {
                completion(r,nil)
            }
            else{
                completion(nil,IOError.encodeFailure(method: "UTF8"))
            }
            
        }catch{
            completion(nil,error)
        }
    }
}
