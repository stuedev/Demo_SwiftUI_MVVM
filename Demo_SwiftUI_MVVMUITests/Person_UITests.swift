//
//  Person_UITests.swift
//  Demo_SwiftUI_MVVMUITests
//
//  Created by Stefan Ueter on 16.04.23.
//

import XCTest


final class Person_UITests: XCTestCase {

    override
    func setUpWithError() throws
    {
        continueAfterFailure = false
    }

    
    func test() throws
    {
        // arrange
        
        let app = XCUIApplication()
        app.launchArguments.append("mockedNetwork")
        app.launch()

        
        
        // act: load
        
        let loadButton = app.buttons["load"]
        
        XCTAssertTrue(loadButton.exists)
        
        loadButton.tap()

        
        
        // assert: person list
        
        let personListCells = app.cells

        XCTAssertTrue(personListCells.firstMatch.waitForExistence(timeout: 3.0))

        XCTAssertEqual(personListCells.count, 10)
        
        
        
        // act: show person details
        
        let firstPersonCell = personListCells.firstMatch
        
        firstPersonCell.tap()
        
        
        
        // assert: person details
        
        let titles =
            [
                "Name",
                "Street",
                "City",
                "Country",
                "Email",
                "Phone",
                "Mobile"
            ]
            .map { "\($0):" }

        XCTAssertTrue(app.staticTexts[titles[0]].waitForExistence(timeout: 1.0))

        titles
            .forEach
            {
                let textElement = app.staticTexts[$0]
                
                XCTAssertTrue(textElement.exists, "StaticText `\($0)` does not exist")
            }
    }
}
