//
//  equateAny.swift
//  Demo_SwiftUI_MVVMTests
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


public
func equateAny
(
    _ lhs: Any,
    _ rhs: Any
)
-> Bool
{
    if let lhs = lhs as? any Equatable
    {
        return innerEquateAny(lhs, rhs)
    }
    else
    {
        return false
    }
}


fileprivate
func innerEquateAny<T: Equatable>
(
    _ lhs: T,
    _ rhs: Any
)
-> Bool
{
    if let rhs = rhs as? T
    {
        return lhs == rhs
    }
    else
    {
        return false
    }
}
