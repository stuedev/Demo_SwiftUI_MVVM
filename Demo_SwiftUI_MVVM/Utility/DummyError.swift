//
//  DummyError.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


struct DummyError: LocalizedError, Equatable
{
    let message: String
    
    var errorDescription: String?
    {
        message
    }
}
