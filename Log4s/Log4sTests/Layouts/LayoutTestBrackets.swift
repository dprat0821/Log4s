//
//  LayoutTestBrackets.swift
//  Log4s
//
//  Created by Daniel Pan on 08/02/2017.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import XCTest
@testable import Log4s

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
        LayoutBrackets().embed(
            Layout.message()
        )
        ._present(evt){ (res, error) in
            print(res)
            XCTAssert(res == "[TestLog]")
        }
        
        //Static
        Layout.brackets().embed(
            Layout.message()
        )
        ._present(evt){ (res, error) in
            print(res)
            XCTAssert(res == "[TestLog]")
        }
    }
    
    func testCustomize() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)
        
        Layout.brackets("{").embed( //Preset symbol
            Layout.message()
            )
            ._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "{TestLog}")
        }
        
        Layout.brackets("!").embed( //Non-preset symbol: will use the same symbol as pair
            Layout.message()
            )
            ._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "!TestLog!")
        }
        
        Layout.brackets(left:"<", right: "|").embed(    //Explicit set the pairs
            Layout.message()
            )
            ._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "<TestLog|")
            }
    }

    
    func testAsBracketLayout()  {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)

        "(".asBracketsLayout().embed(
            Layout.message()
        )
            ._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "(TestLog)")
        }
        
    }
    
    func testMutipleLayers() {
        let evt = Event(id:0,sev:.fatal,tags: ["Tag1","Tag2","Tag3"] , message: "TestLog" , file:#file, method:#function, line: #line)

        Layout.chain([
            "Start:",
            Layout.brackets("{").embed(
                Layout.brackets("<").embed(
                    Layout.brackets("(").embed(
                        Layout.brackets("[").embed(
                            Layout.chain([
                                Layout.tags(dividedBy: "%").uppercased(),
                                Layout.message()
                                ],dividedBy:" ")
                        )
                    )
                )
            ),
            "End"
            ],dividedBy:"\t")._present(evt){ (res, error) in
                print(res)
                XCTAssert(res == "Start:\t{<([TAG1%TAG2%TAG3 TestLog])>}\tEnd")
        }
    }
    
}
