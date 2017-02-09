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
    
    
    func testLayoutDelimiter()  {
        let evt = Event(id:0,sev:.fatal, message: "TestLog" , file:#file, method:#function, line: #line)
        
        XCTAssert(LayoutDelimiter(.space).present(evt) == " ")
        XCTAssert(LayoutDelimiter(.spaces(3)).present(evt) == "   ")
        XCTAssert(LayoutDelimiter(.pipe).present(evt) == " | ")
        XCTAssert(LayoutDelimiter(.tab).present(evt) == "\t")
        XCTAssert(LayoutDelimiter(.breakline).present(evt) == "\n")
        XCTAssert(LayoutDelimiter(.custom("$")).present(evt) == "$")
        XCTAssert(LayoutDelimiter(.customRepeat("$",3)).present(evt) == "$$$")

    }
    
    func testLayoutBrackets() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)
        Layout().chain([
            delimiter.custom("Start:\t"),
            brackets().embed(message()),
            delimiter.custom("\tEnd")
            ])._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "Start:\t[TestLog]\tEnd")
        }
        
    }
    

    
    
    
    
}
