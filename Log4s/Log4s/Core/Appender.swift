//
//  Appender.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-03.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


let dumbLogger = Logger()

public protocol AppenderListener {
    func onLogged(appender: Appender,loggable: Loggable<Any>)
}

public class Appender : LayoutBuilder{
    var logger: Logger
    var layout: Layout
    var listener: AppenderListener?
    
    var queue = [Loggable<Any>]()
    
    func _dump(loggable: Loggable<Any>, completion: ()->()){
        queue.append(loggable)
        _dequeue()
    }
    
    private func _dequeue(){
        if queue.count > 0 {
            if var l = queue.first?.copy(){
                
            }
            
        }
    }
    
    public init(_ logger: Logger = dumbLogger){
        self.logger = logger
    }
    
    
    public func dump(loggable: Loggable<Any>) {
        print("Use the subclass of Appender, please")
    }
}
