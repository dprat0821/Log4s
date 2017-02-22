//
//  LayoutBrackets.swift
//  Log4s
//
//  Created by Daniel Pan on 08/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation

typealias brackets = LayoutBrackets
let defaultLayoutBracketSymbol = "["

public class LayoutBrackets: Layout {
    public var leftBracket: String
    public var rightBracket: String
    public var embededLayout: Layout?
    public var isEliminateWhenEmpty = false
    
    init(_ symbol: String = defaultLayoutBracketSymbol) {
        if symbol == "["{
            leftBracket = "["
            rightBracket = "]"
        }else if symbol == "{"{
            leftBracket = "{"
            rightBracket = "}"
        }else if symbol == "("{
            leftBracket = "("
            rightBracket = ")"
        }else if symbol == "<"{
            leftBracket = "<"
            rightBracket = ">"
        }
        else{
            leftBracket = symbol
            rightBracket = symbol
        }
    }
    
    init(left: String, right: String) {
        leftBracket = left
        rightBracket = right
    }
    
    @discardableResult public func eliminateWhenEmpty() -> Layout{
        isEliminateWhenEmpty = true
        return self
    }
    
    @discardableResult public func embed(_ layout: Layout) -> Layout {
        self.embededLayout = layout
        return self
    }
    
    override public func _present(_ event: Event, completion: @escaping LayoutCompletion) {
        if let embedLayout = self.embededLayout {
            embedLayout._present(event){ (result, error) in
                if let error = error{
                    completion(result, error)
                }
                else{
                    if let next = self.next {
                        next._present(event){ (resultNext, errorNext) in
                            if self.isEliminateWhenEmpty && result == ""{
                                completion( resultNext, error)
                            }
                            else{
                                completion( "\(self.leftBracket)\(result)\(self.rightBracket)\(resultNext)", errorNext)
                            }
                        }
                    }
                    else{
                        if self.isEliminateWhenEmpty && result == ""{
                            completion( "", error)
                        }
                        else{
                            completion( "\(self.leftBracket)\(result)\(self.rightBracket)", error)
                        }
                    }
                }
            }
        }
        else{
            if self.isEliminateWhenEmpty{
                completion("", nil)
            }
            else{
                completion( "\(self.leftBracket)\(self.rightBracket)", nil)
            }
        }
    }
}

extension Layout{
    public static func brackets(_ symbol: String = defaultLayoutBracketSymbol) -> LayoutBrackets{
        return LayoutBrackets(symbol)
    }
    
    public static func brackets(left:String, right: String) -> LayoutBrackets{
        return LayoutBrackets(left:left,right:right)
    }
}

extension String{
    public func asBracketsLayout() -> LayoutBrackets{
        return LayoutBrackets(self)
    }
}
