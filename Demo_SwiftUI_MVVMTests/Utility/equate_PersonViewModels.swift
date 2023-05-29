//
//  equate_PersonViewModels.swift
//  Demo_SwiftUI_MVVMTests
//
//  Created by Stefan Ueter on 16.04.23.
//

import Foundation
@testable import Demo_SwiftUI_MVVM


func equate_PersonViewModels
(
    lhs: Persons.PersonViewModel,
    rhs: Persons.PersonViewModel,
    throw shouldThrow: Bool = false
)
throws
-> Bool
{
    let keyPaths: [PartialKeyPath<Persons.PersonViewModel>] =
        [
            \.displayName,
            \.street,
            \.city,
            \.country,
            \.email,
            \.phone,
            \.mobile,
            \.isFavorite
        ]

    let mismatchingKeyPath =
        keyPaths
            .map
            {
                ($0, equateAny(lhs[keyPath: $0], rhs[keyPath: $0]))
            }
            .first { $0.1 == false }?
            .0
    
    if let mismatchingKeyPath
    {
        if shouldThrow == true
        {
            let lhs = String(describing: lhs[keyPath: mismatchingKeyPath])
            let rhs = String(describing: rhs[keyPath: mismatchingKeyPath])

            let error = EquatePersonViewModels_Error(lhs: lhs,
                                                     rhs: rhs)
            
            throw error
        }
        else
        {
            return false
        }
    }
    else
    {
        return true
    }
}


struct EquatePersonViewModels_Error: LocalizedError
{
    let lhs: String
    
    let rhs: String
    
    
    var errorDescription: String?
    {
        "mismatching, lhs: `\(lhs)`, rhs: `\(rhs)`"
    }
}
