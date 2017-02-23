//
//  AppenderTestBasic.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-22.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest
@testable import Log4s


class AppenderTestBasic: XCTestCase {
    let evtFatalMultipleTags = Event(id:0,sev:.fatal, tags: ["Tag1","Tag2","Tag3"],message: "TestEventMultipleTags" , file:#file, method:#function, line: #line)
    
    let appenderConsole = Appender()
    
    
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
    
    
    func testLogging() {
        appenderConsole._dump(evtFatalMultipleTags)
        appenderConsole._dump(evtFatalMultipleTags){ (err) in
            if let err = err{
                print(err)
            }
        }
    }
    

}
