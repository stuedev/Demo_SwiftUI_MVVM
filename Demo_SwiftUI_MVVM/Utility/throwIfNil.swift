//
//  throwIfNil.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


infix operator ?!: TernaryPrecedence


func ?!<T>
(
    _ optionalObject: T?,
    _ errorMessage: String
)
throws
-> T
{
    guard let unwrappedObject = optionalObject
    else
    {
        let error = ThrowIfNilError(message: errorMessage)
        
        throw error
    }
    
    return unwrappedObject
}


struct ThrowIfNilError: Error
{
    let message: String
}
