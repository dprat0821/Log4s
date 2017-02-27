//
//  AppenderTestBasic.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-22.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest
@testable import Log4s


let tagToTest0 = "Tag1"
let tagToTest1 = "Tag2"

class AppenderTestBasic: XCTestCase {
    let evtFatalMultipleTags = Event(id:0,sev:.info, tags: [tagToTest0,tagToTest1,"Tag3"],message: "TestEventMultipleTags" , file:#file, method:#function, line: #line)
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testSev() {
        let appenderConsole = AppenderConsole()
        //
        // appender with maxSev = .error should not dump an event of .info
        //
        appenderConsole.maxSeverity = .error
        appenderConsole._dump(evtFatalMultipleTags){ error in
            
            guard let error = error else {
                XCTAssert(false)
                return
            }
            print(error.localizedDescription)
            XCTAssert( (error as NSError).code == LogError.rejectSev(event:self.evtFatalMultipleTags , to: appenderConsole, since: self.evtFatalMultipleTags.sev).code )
        }
        //
        // appender with maxSev = .info should dump an event of .info
        //
        appenderConsole.maxSeverity = .info
        appenderConsole._dump(evtFatalMultipleTags){ error in
            
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
            XCTAssert(false)
        }
        
        //
        // appender with maxSev = .debug should dump an event of .info
        //
        appenderConsole.maxSeverity = .debug
        appenderConsole._dump(evtFatalMultipleTags){ error in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
            XCTAssert(false)
        }
    }
    
    func testTags()  {
        let appenderConsole = AppenderConsole()
        appenderConsole.maxSeverity = .debug
        
        //
        // nil filter will log the event evtFatalMultipleTags
        //
        appenderConsole.filterTags = nil
        
        appenderConsole._dump(evtFatalMultipleTags){ error in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
            XCTAssert(false)
            
        }
        
        
        //
        // filters with tagToTest0 will log the event evtFatalMultipleTags
        //
        appenderConsole.filterTags = [tagToTest0]
        
        appenderConsole._dump(evtFatalMultipleTags){ error in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
            XCTAssert(false)

        }
        
        //
        // filters with tagToTest1 and some irrelativeTag will also log the event evtFatalMultipleTags
        //
        appenderConsole.filterTags = [tagToTest1, "irrelativeTag"]
        
        appenderConsole._dump(evtFatalMultipleTags){ error in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
            XCTAssert(false)
        }
        
        //
        // filters with only irrelativeTag will NOT log the event evtFatalMultipleTags
        //
        appenderConsole.filterTags = ["irrelativeTag0","irrelativeTag1"]
        
        appenderConsole._dump(evtFatalMultipleTags){ error in
            guard let error = error else {
                XCTAssert(false)
                return
            }
            print(error.localizedDescription)
            XCTAssert((error as NSError).code == LogError.rejectTag(event: self.evtFatalMultipleTags, to:appenderConsole).code)
        }
    }
}
