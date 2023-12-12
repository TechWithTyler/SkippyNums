//
//  SkippyNumsTests.swift
//  SkippyNumsTests
//
//  Created by Tyler Sheft on 3/2/23.
//  Copyright © 2023 SheftApps. All rights reserved.
//

import XCTest
@testable import SkippyNums

final class SkippyNumsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testGetLayout5Objects() {
		var gameBrain = GameBrain(currentObject: Cow())
		gameBrain.numberOfImagesToShow = 5
		let output = gameBrain.getLayout()
		XCTAssertEqual(output.rows, 2, "Expected 2 rows but found \(output.rows)")
	}

	func testGetLayout9Objects() {
		var gameBrain = GameBrain(currentObject: Cow())
		gameBrain.numberOfImagesToShow = 9
		let output = gameBrain.getLayout()
		XCTAssertEqual(output.rows, 3, "Expected 3 rows but found \(output.rows)")
	}

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
