//
//  TestLayout.swift
//  Log4s
//
//  Created by Daniel Pan on 04/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest
@testable import Log4s

class LayoutTests: XCTestCase {
    
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
    
    
    
    func testLayoutTime() {
        
        let evt = Event(id:0,sev:.fatal, message: "TestLog" , file:#file, method:#function, line: #line)
        
        //Default format
        let layout1 = LayoutTime()
        let output1 = layout1.present(evt)
        print(output1)
        
        //Check default format
        let layout2 = LayoutTime("yy/MM/dd HH:mm:ss")
        let output2 = layout2.present(evt)
        XCTAssert(output1 == output2)
        
        //Custom format
        let layout3 = LayoutTime("HH:mm:ss")
        print(layout3.present(evt))
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
    
    func testLayoutChain() {
        let evt = Event(id:0,sev:.fatal, message: "TestLog" , file:#file, method:#function, line: #line)
        let layout = LayoutTime("yy|MM|dd HH:mm:ss")
        let timePrefix = layout.present(evt)

        
        layout.chain(delimiter.tab())
            .chain(severtiy())
            .chain(delimiter.tab())
            .chain(message())
        
        layout._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "\(timePrefix)\tFATAL\tTestLog" )
        }
        
        
        let layout1 = Layout()
        layout1.chain([
            dateTime("yy|MM|dd HH:mm:ss"),
            delimiter.tab(),
            severtiy(),
            delimiter.breakline(),
            delimiter.space(4),
            message().upperCase()
            ])
        layout1._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "\(timePrefix)\tFATAL\n    TESTLOG" )
        }
    }
}
