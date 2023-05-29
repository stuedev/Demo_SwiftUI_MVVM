//
//  Person_Tests.swift
//  Demo_SwiftUI_MVVMTests
//
//  Created by Stefan Ueter on 25.04.23.
//

import Foundation
@testable import Demo_SwiftUI_MVVM
import XCTest


class Person_Tests: XCTestCase
{
    func test_decodePersonData() throws
    {
        let data = MockData.persons1_raw.data(using: .utf8)!
        
        let persons = try decodePersonData(data)
        
        XCTAssertEqual(persons.count, 10)
    }
}
