//
//  LayoutAppender.swift
//  Log4s
//
//  Created by Daniel Pan on 08/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest
@testable import Log4s

class AppenderBasicTests: XCTestCase {
    
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
    
    func testDefaultLayout() {
        //Use default
        let appender = Appender()
        let evt = Event(id:0,sev:.fatal,message: "TestLog" , file:#file, method:#function, line: #line)
        appender._dump(evt)
        
        // Assign new Layout
        appender.add(layout: LayoutTime())
        appender._dump(evt)
        
        // Assign multiple layout
        appender
            .add(layout: delimiter.tab())
            .add(layout: delimiter("["))
            .add(layout: severtiy().use(Case.upper))
            .add(layout: delimiter("]"))
            .add(layout: delimiter.tab())
            .add(layout: message(Case.upper))
        appender._dump(evt)
        
        
    }
    
}
