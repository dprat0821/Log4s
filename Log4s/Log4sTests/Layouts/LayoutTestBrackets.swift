//
//  LayoutTestBrackets.swift
//  Log4s
//
//  Created by Daniel Pan on 08/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest

class LayoutTestBrackets: XCTestCase {
    
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
    
    
    
    
    func testBasic() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)

        //Basic
        Layout.chain([
            "Start:\t",
            LayoutBrackets().embed(Layout.message()),
            "\tEnd"
            ])._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "Start:\t[TestLog]\tEnd")
        }
    }
    
    func testStatic()  {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)
        
        //Basic
        Layout.chain([
            "Start:\t",
            Layout.brackets().embed(Layout.message()),
            "\tEnd"
            ])._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "Start:\t[TestLog]\tEnd")
        }
    }
    
    func testAsLayout()  {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)

        Layout.chain([
            "Start:\t",
            "(".asBracketsLayout().embed(Layout.message()),
            "\tEnd"
            ])._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "Start:\t(TestLog)\tEnd")
        }
    }
    
    func testCustom() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)

        Layout.chain([
            "Start:\t",
            Layout.brackets("{").embed(
                Layout.brackets("<").embed(
                    Layout.brackets("(").embed(
                        Layout.brackets("[").embed(
                            Layout.chain([
                                Layout.tags(dividedBy: "%").uppercased(),
                                Layout.tab(times: 2),
                                Layout.message()
                            ])
                        )
                    )
                )
            ),
            "\tEnd"
            ])._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "Start:\t{<([TAG1%TAG2%TAG3\t\tTestLog])>}\tEnd")
        }
    }
    
}
