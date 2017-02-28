//
//  SampleLogging.swift
//  SampleSwiftIOS
//
//  Created by Liqing Pan on 2017-02-24.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation
import Log4s

let sample = SampleLogging()

class SampleLogging{
    
    func run() {
        print("---- sampleBasicUsage ----")
        sampleBasicUsage()
        print("---- sampleBasicLayout ----")
        sampleBasicLayout()
        print("---- sampleMultipleAppenders ----")
        sampleMultipleAppenders()
    }
    
    func sampleBasicUsage() {
        /**
         * Basic usage
         */
        logger().log("This is a debug message",severity: .debug)
        
        
        /**
         * Shortcuts for calling with different severities
         */
        Logger.verbose("This is a VERBOSE message")
        Logger.debug("This is a DEBUG message")
        Logger.info("This is an INFO message")
        Logger.warn("This is a WARN message")
        Logger.error("This is an ERROR message")
        Logger.fatal("This is a FATAL message")
        
    }
    
    func sampleBasicLayout() {
        
        // Reset the configuration
        logger().reset()
        
        /**
         * Layout with: prefix + event tags + event message body
         */
        logger().layout = "[Prefix] "
            + Layout.time() + " "
            + Layout.message()
        Logger.error("An error with basic layout fired!")
        
        
        /**
         * A little complex layout (with brackets/embeds)
         */
        logger().layout = "{Prefix} "
            + Layout.brackets("[").embed(Layout.time("HH:mm:ss ") + Layout.severity().uppercased())
            + Layout.space(times: 3)
            + Layout.message()
        Logger.error("Another error with a little complex layout fired!")
    }
    
    func sampleMultipleAppenders() {
        // Reset the configuration
        logger().reset()
        
        let console = AppenderConsole()
        console.maxSeverity = .verbose
        console.layout = Layout.severity().uppercased() + " " + Layout.message()
        logger().add(appender: console)
        
        let localStorage = AppenderPersistent()
        localStorage.maxSeverity = .info
        localStorage.layout =
            Layout.time() + " "
            + Layout.brackets().embed(Layout.tags()) + " "
            + Layout.severity().uppercased() + " "
            + Layout.message()
        
        logger().add(appender: localStorage)
        
        Logger.debug("This debug message will only be dumped to console")
        Logger.error("This error message will be dumped to both the console and localStorage. Check the file after app terminated")
        
        
    }
    
    func sampleTags() {
        let tag1 = "Tag1"
        let tag2 = "Tag2"
        
        // Reset the configuration
        logger().reset().layout = "[Prefix] " + Layout.time() + " "
            + Layout.brackets("[").embed(Layout.tags())
        
        
    }
    
    
    
}
