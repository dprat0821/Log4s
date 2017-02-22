//
//  Appender.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-03.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation

public typealias DumpCompletion = ( Error? ) -> Void
public

let nameSetSeverity = Notification.Name(rawValue: "severity")

public protocol AppenderListener {
    func on(appender: Appender, logged event: Event, with error: Error?)
    func on(appender: Appender, changed: (from: Severity, to: Severity))
    func on(appender: Appender, changed layout: Layout)
}

/**
    The root class of all *Appender*s.
 
    *Appender* dumps *Event*s to a particular destination, eg. XCode console, logging server, MDM logging SDK, etc.
 
    An *Event*s passed in will be dumped only when it matches following critiria:
 
    1. The severity of the event is no greater than *maxSeverity* of this *Appender*
 
    2. *filterTags* of this *Appender* is nil, or its intersection with Event's tags is not empty
    
    Otherwise, it will be ignored.
 
 
 
    *Appender*s are independent from *Logger* and can be shared between *Logger*s.
 */
open class Appender{

    public private(set) var layout: Layout = LayoutMessage()
    public private(set) var isUseDefaultConfig:Bool = true
    
    public func useDefaultConfig(){
        if !isUseDefaultConfig{
            isUseDefaultConfig = true
            self.layout = LayoutMessage()
        }
    }
    
    public var listener: AppenderListener?
    
    public var maxSeverity: Severity = .verbose{
        didSet{
            listener?.on(appender: self, changed: (from:oldValue, to: maxSeverity))
        }
    }
    
    /**
        Assign a set of tags as one of *Appender*'s filter criteria. *Event* configured with at least one tag listed in *filterTags* will match this criteria.
        *Event* matches all filter criterias will be dumped to this *Appender*
        - Attention: if *filterTags* == *nil*, *Event*s configured with any tags (or no tag at all) will be valid for this critiria
     */
    public var filterTags: Set<String>?
    
    /**
        Check whether an event has at least one tag the same with the *Appender*s
     */
    public func matchTags(of event:Event) -> Bool{
        if let filter = filterTags, let tags = event.tags{
            let tagsEvent = Set(tags)
            return filter.intersection(tagsEvent).count == 0
        }
        else{
            return true
        }
    }
    
    private(set) var evtQueue = [(evt: Event,cpl:DumpCompletion?)]()
    private(set) var evtDumping: (evt: Event,cpl:DumpCompletion?)?
    
    
    //
    //  MARK: Layouts
    //
    
    @discardableResult public func add(layout:Layoutable) -> Appender {
        return self.add(layouts: [layout])
    }
    
    @discardableResult public func add(layouts: [Layoutable]) -> Appender {
        if isUseDefaultConfig{
            layout = Layout()
            isUseDefaultConfig = false
        }
        
        layout.chain(layouts)
        listener?.on(appender: self, changed: self.layout)
        return self
    }
    
    
    //
    //  MARK: Dumping
    //
    
    internal func _dump(_ event: Event, completion: DumpCompletion? = nil) {
        
        if event.sev.rawValue <= maxSeverity.rawValue && self.matchTags(of: event){
            evtQueue.append((event,completion))
            _dequeue()
        }
        else{
            completion?(nil)
        }
    }
    
    
    
    private func _didDump(_ event: Event, with error:Error? = nil){
        if let evtTuple = evtDumping{
            evtDumping = nil
            if let l = listener{
                l.on(appender: self, logged: evtTuple.evt, with: error)
            }
            _dequeue()
        }
    }
    
    
    private func _dequeue(){
        if evtDumping == nil {
            if evtQueue.count > 0 {
                if var evtTuple = evtQueue.first {
                    self.evtQueue.removeFirst()
                    evtTuple = (evt: evtTuple.evt.copy(),cpl: evtTuple.cpl)
                    evtDumping = evtTuple
                    
                    layout._present(evtTuple.evt){ (modifiedMessage, error) in
                        if let error = error{   // There are errors while layouting
                            evtTuple.cpl?(error)
                            self._didDump(evtTuple.evt,with: error)
                        }
                        else{
                            evtTuple.evt.message = modifiedMessage
                            self.dump(evtTuple.evt){ (dumpError) in
                                evtTuple.cpl?(dumpError)
                                self.listener?.on(appender: self, logged: evtTuple.evt, with: dumpError)
                                self._didDump( evtTuple.evt,with:dumpError)
                            }
                        }
                    }
                }
                else{
                    evtQueue.removeFirst()
                    _dequeue()
                }
            }
        }
    }
    
    /**
        Dump an event to *Appender* with exceptions.
     
        override this method to implement the logic of dumping logs to a particular *Appender* with a completion to handle exceptions. eg. Remote server, MDM API, etc.
        
        - parameters:
            - event: The event to be logged
            - completion: (Optional) The closure to handle possible exceptions during dumping.
     
     */
    open func dump(_ event: Event, completion: DumpCompletion? = nil){
        print(event.message)
        completion?(nil)
    }
    
}
