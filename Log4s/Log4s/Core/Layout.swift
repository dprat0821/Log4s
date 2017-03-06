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

let defaultChainDelimiter = " "

extension String : Layoutable {

    public func asLayout() -> Layout{
        return LayoutDelimiter.init(self, count: 1)
    }
    
    public static func + (left: String, right:Layoutable) -> Layout {
        let r = left.asLayout()
        r.next = right.asLayout()
        return r
    }
}

func noLayoutClosure(event: Event) -> String { return "" }

open class Layout:Layoutable {
    public var letterCase: Case = Case.normal

    public internal(set) var next: Layout?
    
    var presentClosure: (Event)->String
    
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
    
    @discardableResult public func chain(_ layout:Layoutable, dividedBy delimiter:String = defaultChainDelimiter) -> Layout{
        self.last().next = delimiter + layout.asLayout()
        return self
    }
    
    @discardableResult public func chain(_ layouts:[Layoutable], dividedBy delimiter:String = defaultChainDelimiter) -> Layout{
        var nowNode = self
        
        for l in layouts{
            let node = l.asLayout()
            nowNode.chain(node, dividedBy: delimiter)
            nowNode = node
        }
        return self
    }
    
    
    static public func chain(_ layouts:[Layoutable], dividedBy delimiter:String = defaultChainDelimiter) -> Layout{
        if layouts.count == 0 {
            return Layout()
        }
        else{
            let root = layouts[0].asLayout()
            var last = root.last()
            for l in layouts[1...layouts.count - 1 ] {
                last.chain(l,dividedBy: delimiter)
                last = last.last()
            }
            return root
        }
        
    }
    
    static public func + (left: Layout, right: Layoutable) -> Layout {
        left.last().next = right.asLayout()
        return left
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
        return self.presentClosure(event)
    }
    
    public init(_ presentClosure:@escaping (Event)->String = noLayoutClosure) {
        self.presentClosure = presentClosure
        
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




