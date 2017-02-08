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
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
    

    
    func testLayoutChain() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)
        let layout = LayoutTime("yy|MM|dd HH:mm:ss")
        let timePrefix = layout.present(evt)

        //Chain one layout every time
        layout.chain(delimiter.tab())
            .chain(severtiy())
            .chain(delimiter.tab())
            .chain(message())
        
        layout._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "\(timePrefix)\tFATAL\tTestLog" )
        }
        
        // Chain multiple layout at once
        Layout().chain([
            dateTime("yy|MM|dd HH:mm:ss"),
            delimiter.tab(),
            severtiy(.upper),
            delimiter.breakline(),
            delimiter.space(4),
            message(.lower)
            ])
            ._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "\(timePrefix)\tFATAL\n    TESTLOG" )
        }
    }
    

    func  testLayoutJoinChains() {
        // Join two chained layouts
        
        let layoutNiceTags = Layout().chain([
            delimiter.custom("["),
            tags("#").to(.upper),
            delimiter.custom("]")
            ])
        let layoutMessageWithTime = Layout().chain([
            delimiter.custom("["),
            ])
    }
    
    
}
