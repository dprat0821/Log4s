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
    func on(appender: Appender, changeSevertiy: (from: Severity, to: Severity))
    func on(appender: Appender, changeLayout: (from: Layout?,to:Layout?))
}

/**
    The root class of all *Appender*s.
 
 */
open class Appender{

    public var layout: Layout? {
        willSet{
            listener?.on(appender: self, changeLayout: (from:layout,to:newValue))
        }
    }
    
    
    public var listener: AppenderListener?
    
    public var maxSeverity: Severity = .verbose{
        willSet{
            listener?.on(appender: self, changeSevertiy: (from:maxSeverity, to: newValue))
        }
        didSet{
            NotificationCenter.default.post(name: nameSetSeverity, object: self, userInfo: nil)
        }
    }
    
    /**
        Assign a set of tags as one of *Appender*'s filter criteria. *Event* configured with at least one tag listed in *filterTags* will match this criteria.
        *Event* matches all filter criterias will be dumped to this *Appender*
        - Attention: if *filterTags* == *nil*, *Event*s configured with any tags (or no tag at all) will be valid for this critiria
     */
    public var filterTags: Set<String>?
    public func isMatchTags(event:Event) -> Bool{
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
    
    
    
    
    internal func _dump(_ event: Event, completion: DumpCompletion? = nil) {
        var bValid = false
        if event.sev.rawValue <= maxSeverity.rawValue{
            if let filter = filterTags, let tags = event.tags{
                let tagsEvent = Set(tags)
                
                bValid = filter.intersection(tagsEvent).count != 0
                
            }
            else{
                bValid = true
            }
        }
        
        if bValid{
            evtQueue.append((event,completion))
            _dequeue()
        }
        else{
            completion?(nil)
        }
    }
    
    
    
    private func _didLog(with error:Error? = nil){
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
                    
                    if let layout = layout {    // Use the layout to modify event first
                        layout._present(evtTuple.evt){ (modifiedMessage, error) in
                            if let error = error{   // There are errors while layouting
                                evtTuple.cpl?(error)
                                self._didLog(with: error)
                            }
                            else{
                                evtTuple.evt.message = modifiedMessage
                                self.dump(evtTuple.evt){ (dumpError) in
                                    evtTuple.cpl?(dumpError)
                                    self._didLog(with:dumpError)
                                }
                            }
                        }
                    }
                    else{   // w/o layout assigned, use the original event
                        self.dump(evtTuple.evt){ (dumpError) in
                            evtTuple.cpl?(dumpError)
                            self._didLog(with: dumpError)
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
        self.dump(event)
        completion?(nil)
    }
    
}
