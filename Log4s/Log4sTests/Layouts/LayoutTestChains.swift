//
//  LayoutTestChains.swift
//  Log4s
//
//  Created by Daniel Pan on 08/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest
@testable import Log4s

class LayoutTestChains: XCTestCase {
    
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
    
    func testLayoutChain() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)
        let layout = LayoutTime("yy|MM|dd HH:mm:ss")
        let timePrefix = layout.present(evt)
        
        //Chain layouts one by one
        layout.chain(delimiter.tab())
            .chain(severtiy(use: upperCase))
            .chain(delimiter.space(2))
            .chain(message())
        
        layout._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "\(timePrefix)\tFATAL\tTestLog" )
        }
        
        // Chain multiple layouts with one call
        Layout().chain([
            dateTime("yy|MM|dd HH:mm:ss"),
            delimiter.tab(),
            severtiy().useUpperCase,
            delimiter.breakline(),
            //delimiter.space(4),
            delimiter.spaces(4),
            message.upperCase
            ])
            ._present(evt){ (res, error) in
                print(res)
                XCTAssert( res == "\(timePrefix)\tFATAL\n    testlog" )
        }
        
    }
    
    // Call chains for multiple times
    func testLayoutChainsMultipleTimes() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)
        
        let layout = Layout()
        layout
            .chain(severtiy(use: .upper))
            .chain(delimiter.tab())
        
        layout.chain([
            severtiy(use:.upper),
            delimiter.breakline()
            ])
        
        layout
            .chain(delimiter.space(4))
            .chain(message().use(.upper))
        
        layout._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "\tFATAL\n    TESTLOG" )
        }
    }
    
    func  testLayoutJoinChains() {
        // Join two chained layouts
        
        let layoutNiceTags = Layout().chain([
            delimiter.custom("["),
            tags("#").use(.upper),
            delimiter.custom("]")
            ])
        let layoutMessageWithTime = Layout().chain([
            delimiter.custom("["),
            ])
        
        
    }
    
}
