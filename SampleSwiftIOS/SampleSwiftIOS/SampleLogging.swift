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
        print("\n---- Basic Usage ----")
        sampleBasicUsage()
        print("\n---- Use of Some Basic Build-in Layout Components ----")
        sampleBasicLayout()
        print("\n---- Use Multiple Appenders to Dump Log to Different Destinations----")
        sampleMultipleAppenders()
        print("\n---- Use Tags to Assist Log Filters ----")
        sampleTags()
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
        
        // Appender 1: Console
        let console = AppenderConsole()
        console.maxSeverity = .verbose
        console.layout = Layout.severity().uppercased() + " " + Layout.message()
        logger().add(appender: console)
        
        // Appender 2: Local storage in the cache path
        let localStorage = AppenderPersistent()
        localStorage.maxSeverity = .info
        localStorage.layout =
            Layout.time() + " "
            + Layout.brackets().embed(Layout.tags()) + " "
            + Layout.severity().uppercased() + " "
            + Layout.message()
        
        logger().add(appender: localStorage)
        
        Logger.debug("This debug message will only be dumped to console")
        Logger.error("This error message will be dumped to both the console and localStorage")
        
        
    }
    
    func sampleTags() {
        let tagNetwork = "Network"
        let tagUserAction = "UserAction"
        let tagScene1 = "Scene1"
        let tagScene2 = "Scene2"
        
        
        // Reset the configuration with new layout
        logger().reset().layout = "[Prefix] " + Layout.time() + " "
            + Layout.brackets("[").embed(Layout.tags()) + " " + Layout.message()
        
        //
        Logger.info("User click a button in scene1", tags: [tagUserAction,tagScene1])
        Logger.error("Network failure in scene2", tags: [tagNetwork,tagScene2])
        
    }
    
    
    
}
