//
//  SimpleXMLNode.swift
//  Simple XML to Dictionary
//
//  Created by Nicolás Fernando Miari on 2016/04/15.
//  Copyright © Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Auxiliary class used to build a node hierarchy in memory, then convert it
 to ditionaries (recursively).
 */
class SimpleXMLNode: NSObject {
    
    /// Element (XML tag) name.
    var name:String

    
    /// Parent (containing) node.
    weak var parent:SimpleXMLNode?

    
    /// Child (contained) nodes.
    private (set) var children:[SimpleXMLNode]?
    
    
    /// Text content (for leaf nodes).
    var content:String?
    
    
    /**
     Designated initializer. Only the name is required.
     */
    init(name:String) {
        self.name = name
        
        super.init()
    }
    
    
    /**
     Child's `parent` property is set to the receiver. No consistency checks are 
     performed (e.g., whether the child is equal to the receiver or an 
     ancestor).
     */
    func addChild(node:SimpleXMLNode) {
        if children == nil {
            children = [SimpleXMLNode]()
        }
        
        children?.append(node)
        
        node.parent = self
    }
    
    
    /** 
     (Recursive)
     */
    func dictionaryRepresentation() -> AnyObject {
        
        guard children?.count > 0 else {
            // Node is a leaf (i.e., terminal) element. Return string value:
            return content ?? ""
        }
        
        // Node has children. Return array or dictionaries...
        
        // Group all the dictionary representations for children with the same 
        // name into arrays keyed by said name:
        
        var childrenByCommonName = [String : [AnyObject]]()
        
        for child in children! {
            
            let childRepresentation = child.dictionaryRepresentation()
            
            if var existingArray = childrenByCommonName[child.name]{

                existingArray.append(childRepresentation)
                childrenByCommonName[child.name] = existingArray
            }
            else{
                childrenByCommonName[child.name] = [childRepresentation]
            }
        }
        
        var dictionary = [String : AnyObject]()
        
        for (name, array) in childrenByCommonName {
        
            if array.count == 1 {
                // Array is superfluous (contains only one node); simplify by
                // inserting its only element at the root:
                dictionary[name] = array[0]
            }
            else{
                // Array contains one or more elements of the same name; add it
                // as-is:
                dictionary[name] = array
            }
        }
        
        return dictionary
    }
    
}


