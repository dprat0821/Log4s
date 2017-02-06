//
//  Layout.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-03.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public typealias LayoutCompletion = (Event, Error?) -> Void

open class Layout {
    
    public internal(set) var next: Layout?
    
    func _modify(_ event:Event, completion: LayoutCompletion){
        let out = modify(event)
        if let next = self.next{
            next._modify(out, completion: completion)
        }
        else{
            completion(out, nil)
        }
    }
    
    public func chain(layout:Layout) -> Layout{
        self.next = layout
        return layout
    }
    
    open func modify(_ event:Event) -> Event {
        return event
    }
}

open class AsyncLayout : Layout {
    final override func _modify(_ event:Event, completion: LayoutCompletion){
        modify(event){ (result, error) in
            if let error = error{
                completion(result, error)
            }
            else{
                if let next = self.next{
                    next._modify(result, completion: completion)
                }
                else{
                    completion(result, nil)
                }
            }
        }
    }
    
    open func modify(_ event:Event, completion: LayoutCompletion) {
        completion(event,nil)
    }
}
