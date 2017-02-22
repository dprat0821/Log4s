//
//  TestLayout.swift
//  Log4s
//
//  Created by Daniel Pan on 04/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest
@testable import Log4s

class LayoutCustomDelay: AsyncLayout {
    override func present(_ event: Event, completion: @escaping LayoutCompletion) {
        delay(1){
            completion("[DELAYED]\(event.message)", nil)
        }
    }
}

class MyAppenderListener: AppenderListener {
    func on(appender: Appender, logged event: Event, with error: Error?){
        
    }
    func on(appender: Appender, changeSevertiy: (from: Severity, to: Severity)){
    }
    func on(appender: Appender, changedTo layout: Layout){
    }
}

class LayoutTestDelimiters: XCTestCase {
    
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
    
    /**String delimiter layouts can be instantiated via two ways. */
    
    func testLayoutDelimiterBasic()  {
        let evt = Event(id:0,sev:.fatal, message: "TestLog" , file:#file, method:#function, line: #line)
        
        XCTAssert(Layout.space().present(evt) == " ")
        XCTAssert(Layout.space(times:3).present(evt) == "   ")
        XCTAssert(Layout.pipe().present(evt) == "|")
        XCTAssert(Layout.tab().present(evt) == "\t")
        XCTAssert(Layout.breakline().present(evt) == "\n")
        XCTAssert(Layout.string("$").present(evt) == "$")
        XCTAssert(Layout.string("$",times:3).present(evt) == "$$$")
    }
    
    
    func testLayoutDelimiterAsLayout() {
        let evt = Event(id:0,sev:.fatal, message: "TestLog" , file:#file, method:#function, line: #line)
        
        XCTAssert(space.asLayout().present(evt) == " ")
        XCTAssert(space.asLayout(times: 3).present(evt) == "   ")
        XCTAssert(pipe.asLayout().present(evt) == "|")
        XCTAssert(tab.asLayout().present(evt) == "\t")
        XCTAssert(breakline.asLayout().present(evt) == "\n")
        XCTAssert("$".asLayout().present(evt) == "$")
    }
    
    
}
