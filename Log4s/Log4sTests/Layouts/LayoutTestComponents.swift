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
        
        
    }
    
    
    
    func testLayoutTagsBasic()  {
        //One Tag
        let evt1 = Event(id:0,sev:.fatal, tags: ["Tag1"],message: "TestLog" , file:#file, method:#function, line: #line)
        
        let timeFormat = "HH:mm:ss"
        let outputTime = LayoutTime(timeFormat).present(evt1)
        
        Layout().chain([
            Layout.time(timeFormat),
            " [",
            Layout.tags().uppercased(),
            "]",
            Layout.tab(2),
            Event.message(),
            ])._present(evt1){ (res, error) in
                print(res)
                XCTAssert( res == "\(outputTime) [TAG1]\t\ttestlog" )
        }
        
        //Tag with uppercase
        Layout().chain([
            delimiter("["),
            tags().use(.upper),
            delimiter("]"),
            delimiter.tab(),
            message()
            ])._present(evt1){ (res, error) in
                print(res)
                XCTAssert( res == "[TAG1]\tTestLog" )
        }
    }
    
    func testLayoutTagsMutipleTags() {
        let evt2 = Event(id:0,sev:.fatal, tags: ["Tag1","Tag2","Tag3"],message: "TestLog" , file:#file, method:#function, line: #line)
        
        //Mutiple tags
        Layout().chain([
            delimiter("["),
            tags(),
            delimiter("]"),
            delimiter.tab(),
            message()
            ])._present(evt2){ (res, error) in
                print(res)
                XCTAssert( res == "[Tag1|Tag2|Tag3]\tTestLog" )
        }
        
        //Custom tag delimiter
        Layout().chain([
            delimiter.custom("["),
            tags(","),
            delimiter.custom("]"),
            delimiter.tab(),
            message()
            ])._present(evt2){ (res, error) in
                print(res)
                XCTAssert( res == "[Tag1,Tag2,Tag3]\tTestLog" )
        }
    }
    
    func testLayoutTagsWithoutTag() {
        // No tag
        let evt = Event(id:0,sev:.fatal,message: "TestLog" , file:#file, method:#function, line: #line)
        Layout().chain([
            delimiter.custom("["),
            tags(),
            delimiter.custom("]"),
            delimiter.tab(),
            message()
            ])._present(evt){ (res, error) in
                print(res)
                XCTAssert( res == "[]\tTestLog" )
        }
    }
    
    
    
    func testLayoutMessage()  {
        let evt = Event(id:0,sev:.warn, message: "TestLog" , file:#file, method:#function, line: #line)
        LayoutMessage(.lower)._present(evt){ (res, error) in
            print(res)
            XCTAssert( res == "testlog" )
        }
        
    }
}
