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
        print("\n---- Use Multiple Appenders to Dump Log to Different Destinations with Different Layouts and MaxSeverities----")
        sampleMultipleAppenders()
        print("\n---- Set Tags to Categorize Logs and Filter Them for Different Appenders ----")
        sampleTags()
        print("\n---- Use multiple loggers----")
        sampleMutipleLoggers()
        print("\n---- Define Custom Levels ----")
        sampleCustomLevel()
        
    }
    
    func sampleBasicUsage() {
        /**
         * Basic usage
         */
        Logger.log("This is a logging message",severity:.debug)
        
        
        /**
         * Shortcuts for calling with different severities
         */
        Logger
            .verbose("This is a VERBOSE message")
            .debug("This is a DEBUG message")
            .info("This is an INFO message")
            .warn("This is a WARN message")
            .error("This is an ERROR message")
            .fatal("This is a FATAL message")
        
    }
    
    func sampleBasicLayout() {
        
        // Reset the configuration
        Logger.reset()
        
        /**
         * Layout with: prefix + event tags + event message body
         */
        Logger.use(layout: [
            "[Prefix]",
            Layout.time(),
            Layout.message()
            ])
            .error("An error with basic layout fired!")
        
        
        /**
         * A little complex layout (with brackets/embeds)
         */
        Logger.layout = "{Prefix} "
            + Layout.brackets("[").embed(Layout.time("HH:mm:ss ") + Layout.severity().uppercased())
            + Layout.space(times: 3)
            + Layout.message()
        Logger.error("Another error with a little complex layout fired!")
        
        /**
         * Use closure for custom layout
         */
        Logger.use(layout: Layout(){ (event) -> String in
            return "'MyLayout' [\(String(describing: event.sev).uppercased())] \(event.message)"
        })
        Logger.error("This is an error message presented by customized layout")
    }
    
    func sampleMultipleAppenders() {
        // Reset the configuration
        Logger.reset()
        
        // Appender 1: Console
        let console = AppenderConsole()
        console.maxSeverity = .verbose
        console.layout = Layout.severity().uppercased() + " " + Layout.message()
        Logger.add(appender: console)
        
        // Appender 2: Local storage in the cache path
        let localStorage = AppenderPersistent()
            .use(maxSev: .info)
            .use(layout: [
                Layout.time(),
                Layout.brackets().embed(Layout.tags()),
                Layout.severity().uppercased(),
                Layout.message()
                ])

        
        Logger
            .add(appender: localStorage)
            .debug("This debug message will only be dumped to console")
            .error("This error message will be dumped to both the console and localStorage")

        
        
    }
    
    func sampleTags() {
        let tagNetwork = "Network"
        let tagUserAction = "UserAction"
        let tagScene1 = "Scene1"
        let tagScene2 = "Scene2"
        
        
        // Reset the configuration with new layout
        Logger.reset().layout = "[Prefix] " + Layout.time() + " "
            + Layout.brackets("[").embed(Layout.tags()) + " " + Layout.message()
        
        // Try the logs with tags
        Logger.info("User click a button in scene1", tags: [tagUserAction,tagScene1])
        Logger.error("Network failure in scene2", tags: [tagNetwork,tagScene2])
        
        //Set "tag filters" for different appenders
        let console = AppenderConsole()
        console.filterTags = [tagScene1,tagUserAction]
        Logger.add(appender: console)
        
        // Try the logs after filter
        Logger.info("This message without any tag will be logged in the console appender")
        Logger.error("This message about UserAction will be logged in the console appender", tags: [tagUserAction])
        Logger.warn("This message about Network will not be logged in the console appender", tags: [tagNetwork])
    }
    
    func sampleMutipleLoggers() {
        // Config default logger with console appender only
        logger().reset()
        // Config a new logger with two appenders
        
        let anotherLogger = logger("another")
        anotherLogger.reset()
            .add(appender: AppenderPersistent().use(layout: [
                Layout.severity().uppercased(),
                Layout.message()
                ],dividedBy:"\t"))
            .add(appender: AppenderConsole().use(layout: [
                "[Prefix]",
                Layout.time(),
                Layout.brackets("[").embed(Layout.tags().dividedBy(by: "|")),
                Layout.severity().uppercased(),
                Layout.message()
                ]))
        
        logger().log("This message comes from the default logger", severity: .info, tags: ["Tag0"])
        anotherLogger.log("This message comes from another logger", severity: .error, tags: ["Tag1","Tag2"])
    }
    
    
    
    func sampleCustomLevel() {
        
        Logger
            .reset()
            .use(maxSev:.error)
            .use(layout: [
                Layout.brackets().embed(Layout.severity().uppercased()),
                Layout.message()
            ])
            .log("This message with custom severity 'notVeryVerbose' will not be logged", severity: .notVeryVerbose)
            .log("This message with custom severity 'terribleError' will be logged", severity: .terribleError)
        
    }
}

// Custom levels
extension Severity{
    static let notVeryVerbose = Severity(rawValue: 550,desp:"notVeryVerbose")
    static let terribleError = Severity(rawValue: 150,desp:"terribleError")
}
