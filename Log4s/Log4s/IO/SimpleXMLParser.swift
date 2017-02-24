//
//  SimpleXMLParser.swift
//  Simple XML to Dictionary
//
//  Created by Nicolás Fernando Miari on 2016/04/15.
//  Copyright © Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Elements are converted to `String`, `Array<AnyObject>` or 
 `Dictionary<String, AnyObject>`.
 
 1. Elements containing only text are converted to `String`.
 2. Elements containing other elements are converted to `Dictionary`, and the 
    children are added to the dictionary wiyth their element names as keys.
 
 If one or more sibling elements share the same name, they are grouped in an 
 array and that is added to the parent dictionary, with the shared name as key.
 
 Example:
 
     <root>
        <user>
            <name>John</name>
            <age>23</age>
        </user>
        <device>
            <name>iPhone</device>
        </device>
        <device>
            <name>iPad</device>
        </device>
     </root>
 
 Becomes:
 
     [
         "user" : {
            "name" : "John",
            "age"  : "23"
         }
         "device" : {
            { "name" : "iPhone" },
            { "name" : "iPad" },
         }
     ]
 
 */
class SimpleXMLParser: NSObject {
    
    /// Root node.
    fileprivate var root:SimpleXMLNode!
    
    
    /// Node being currently built.
    fileprivate var currentNode:SimpleXMLNode!
    
    
    /// Text being parsed. Goes into the current node.
    fileprivate var characters:String!
    
    
    /// Cocoa parser object.
    fileprivate let parser: XMLParser!
    
    
    ///
    typealias XMLParseCompletionHandler = (_ result:[String : AnyObject]) -> (Void)
    
    
    ///
    fileprivate let completionHandler:XMLParseCompletionHandler
    
    ///
    typealias XMLParseErrorHandler = (_ error:NSError) -> (Void)
    
    ///
    fileprivate let errorHandler:XMLParseErrorHandler
    
    ///
    var removeNamespaces:Bool = false
    
    
    /**
     Initializes the parser object. Actual parsing does not occur
     until `start()` is not called.
     
     - parameter dataToParse: NSData object representing the input XML (encoded as UTF8).
     - parameter parseCompletionHandler: Closure to execute if and when the parsing finishes successfully.
     - parameter parseErrorHandler: Closure to execute if and when the parser encounters an error and aborts.
     */
    init(withSourceData dataToParse:Data,
        parseCompletionHandler:@escaping XMLParseCompletionHandler,
        parseErrorHandler:@escaping XMLParseErrorHandler
        ) {
        
        completionHandler = parseCompletionHandler
        errorHandler      = parseErrorHandler
        parser            = XMLParser(data: dataToParse)
        
        super.init()
        
        parser.delegate = self
    }
    
    
    /**
     Begins the parsing.
     */
    func start() {
        
        if removeNamespaces {
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = false
        }
        
        parser.parse()
    }
    
}


// .............................................................................
// MARK: - NSXMLParserDelegate


extension SimpleXMLParser: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        root = SimpleXMLNode(name: "xml")
        currentNode = root
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        // This GCD call avoids the error "NSXMLParser does not support
        // reentrant parsing" if (for example) the caller initiates a second 
        // parse task from within the completion handler:
        DispatchQueue.main.async {
            
            // Convert the assembled node hierarchy into nested dictionaries/
            // arrays/strings (i.e., JSON), and pass back to caller:
            self.completionHandler(self.root.dictionaryRepresentation() as! [String : AnyObject])
        }
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        // Pass error as-is to registered handler:
        errorHandler(parseError as NSError)
    }
    
    
    func parser(_ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String]) {
        
        // Reset string, otherwise it adds e.g. newlines between elements,
        // indent space, etc:
        characters = nil
        
        // Create a new node and set as child of the until-now-in-progress node:
        let newNode = SimpleXMLNode(name: elementName)
        
        currentNode.addChild(newNode)
        
        // Also, make node in progress:
        currentNode = newNode
        
        // (Pushed stack)
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if characters == nil {
            characters = ""
        }
        
        characters.append(string)
    }
    
    
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?) {
        
        // If present, set text content of node: (LEAF)
        if characters != nil {
            currentNode.content = characters
            characters = nil
        }
        
        // Pop node stack, back to parent level:
        currentNode = currentNode.parent
    }

}
