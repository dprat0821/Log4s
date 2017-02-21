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
        layout.chain(Layout.tab())
            .chain(Layout.severity().uppercased())
            .chain(Layout.space(times:2))
            .chain(Layout.message())
        
        layout._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "\(timePrefix)\tFATAL  TestLog" )
        }
        
        
        
    }
    
    func testLayoutChainWithOneCall() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)
        
        // Chain multiple layouts with one call
        Layout.chain([
            Layout.tab(),
            Layout.severity().uppercased(),
            Layout.breakline(),
            Layout.spaces(4),
            Layout.message()
            ])
            ._present(evt){ (res, error) in
                print(res)
                XCTAssert( res == "\tFATAL\n    testlog" )
        }
    }
    
    func testLayoutChainWithString() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)

        Layout.chain([
            "Start:",
            Layout.severity(),
            "  Body: ",
            Layout.message()
            ])
            ._present(evt){ (res, error) in
                print(res)
                XCTAssert( res == "Start:fatal  Body: testlog" )
    }
    
    // Call chains for multiple times
    func testLayoutChainsMultipleTimes() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)
        
        let layout = Layout()
        layout.chain(Layout.severity())
        
        layout.chain([
            Layout.breakline(),
            Layout.space(4)
            ])
        
        layout.chain(Layout.message())
        
        layout._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "FATAL\n    TESTLOG" )
        }
    }
    
    func  testLayoutJoinChains() {
        // Join two chained layouts
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)

        let layoutNiceTags = Layout.chain([
            Layout.brackets().embed(
                Layout.tags(dividedBy:",").uppercased()
            ),
            Layout.space(times:2)
            ])
        
        let layoutNiceSev = Layout.chain([
            Layout.brackets("{").embed(
                Layout.severity().uppercased()
            ),
            Layout.space(times:2)
            ])
        
        Layout.chain([
            layoutNiceTags,
            layoutNiceSev,
            Layout.message()
            ])._present(evt){ (res,error) in
                print(res)
                XCTAssert(res == "[TAG1,TAG2,TAG3]  {FATAL}  TestLog")
        }
        
    }
    
}
