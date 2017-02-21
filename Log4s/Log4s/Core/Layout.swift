//
//  Layout.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-03.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


public typealias LayoutCompletion = (String, Error?) -> Void



public protocol Layoutable {
    func asLayout() -> Layout
}


extension String : Layoutable {

    public func asLayout() -> Layout{
        return LayoutDelimiter.init(self, count: 1)
    }
}

open class Layout:Layoutable {
    public var letterCase: Case = Case.normal

    public internal(set) var next: Layout?
    
    public final func asLayout() -> Layout{
        return self
    }
    
    internal func _present(_ event:Event, completion: @escaping LayoutCompletion){
        let out = present(event)
        if let next = self.next{
            next._present(event){(result, error) in
                completion("\(out)\(result)",error)
            }
        }
        else{
            completion(out, nil)
        }
    }
    
    func last()-> Layout {
        var nodeNow = self
        while true {
            if let next = nodeNow.next{
                nodeNow = next
            }
            else{
                break
            }
        }
        return nodeNow
    }
    
    @discardableResult public func chain(_ layout:Layoutable) -> Layout{
        let last = self.last()
        last.next = layout.asLayout()
        return self
    }
    
    @discardableResult public func chain(_ layouts:[Layoutable]) -> Layout{
        var nowNode = self
        
        for l in layouts{
            let node = l.asLayout()
            nowNode.chain(node)
            nowNode = node
        }
        return self
    }
    
    public func resetChain() -> Layout{
        next = nil
        return self
    }
    
    @discardableResult public func uppercased()  -> Self {
        self.letterCase = .upper
        return self
    }
    
    @discardableResult public func lowercased()  -> Self {
        self.letterCase = .lower
        return self
    }
    
    /**
     override this method
     */
    open func present(_ event:Event) -> String {
        return ""
    }
}


open class AsyncLayout : Layout {
    override func _present(_ event:Event, completion: @escaping LayoutCompletion){
        present(event){ (out, error) in
            if let error = error{
                completion(out, error)
            }
            else{
                if let next = self.next{
                    next._present(event){(result,errorNext) in
                        completion("\(out)\(result)",errorNext)
                    }
                }
                else{
                    completion(out, nil)
                }
            }
        }
    }
    
    open func present(_ event:Event, completion: @escaping LayoutCompletion) {
        completion("",nil)
    }
}




