//
//  Layout.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-03.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


typealias LayoutCompletion = (Loggable<Any>) throws -> Void

public class Layout {
    func _modify(loggable:Loggable<Any>, completion: @escaping LayoutCompletion ) throws{
        do{
            try modify(loggable: loggable){ (result) in
                if let next = self.next {
                    do {
                        try next.modify(loggable: result){ (resultNext) in
                            try completion(resultNext)
                        }
                    }
                }
                else{
                    try completion(loggable)
                }
            }
        }catch{
            throw error
        }
        
    }
    
    //Rewrite this
    func modify(loggable:Loggable<Any>, completion: @escaping LayoutCompletion ) throws {
        do{
            try completion(loggable)
        }catch{
            throw error
        }
        
    }
    
    var next: Layout?
}
