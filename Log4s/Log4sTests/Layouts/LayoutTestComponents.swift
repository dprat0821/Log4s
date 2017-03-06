//
//  LayoutTestsComponents.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-08.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest
@testable import Log4s


class LayoutTestComponents: XCTestCase {
    
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
        
        //Another way for instantiation
        let layout4 = Layout.time("yy/MM/dd HH:mm:ss")
        XCTAssert(layout4.present(evt) == output1)
    }
    
    
    
    func testLayoutTagsBasic()  {
        //One Tag
        let evt1 = Event(id:0,sev:.fatal, tags: ["Tag1"],message: "TestLog" , file:#file, method:#function, line: #line)
        
        XCTAssert(Layout.tags().present(evt1) == "Tag1")
        XCTAssert(Layout.tags().uppercased().present(evt1) == "TAG1")
        XCTAssert(Layout.tags().lowercased().present(evt1) == "tag1")
        
    }
    
    func testLayoutTagsMutipleTags() {
        let evt2 = Event(id:0,sev:.fatal, tags: ["Tag1","Tag2","Tag3"],message: "TestLog" , file:#file, method:#function, line: #line)
        
        //Mutiple tags
        XCTAssert(Layout.tags().present(evt2) == "Tag1|Tag2|Tag3")
        XCTAssert(Layout.tags().uppercased().present(evt2) == "TAG1|TAG2|TAG3")
        XCTAssert(Layout.tags().lowercased().present(evt2) == "tag1|tag2|tag3")
        
        
        //Custom tag delimiter
        
        XCTAssert(Layout.tags(dividedBy:",").present(evt2) == "Tag1,Tag2,Tag3")
    }
    
    func testLayoutTagsWithoutTag() {
        // No tag
        let evt = Event(id:0,sev:.fatal,message: "TestLog" , file:#file, method:#function, line: #line)
        XCTAssert(Layout.tags().present(evt) == "")

    }
    
    func testLayoutSev()  {
        let evt = Event(id:0,sev:.fatal,message: "TestLog" , file:#file, method:#function, line: #line)
        XCTAssert(Layout.severity().present(evt) == "FATAL")
        XCTAssert(Layout.severity().uppercased().present(evt) == "FATAL")
        XCTAssert(Layout.severity().lowercased().present(evt) == "fatal")

    }
    
    func testLayoutMessage()  {
        let evt = Event(id:0,sev:.warn, message: "TestLog" , file:#file, method:#function, line: #line)
        
        XCTAssert(Layout.message().present(evt) == "TestLog")
        XCTAssert(Layout.message().uppercased().present(evt) == "TESTLOG")
    
    }
}
