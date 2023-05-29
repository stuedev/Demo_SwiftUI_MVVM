//
//  Dependencies_Mock.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


class Dependencies_Mock: DependenciesProtocol
{
    let persons_mocked: [Person]
    
    let personService: PersonServiceProtocol
    
    
    init
    (
        persons_mocked: [Person]
    )
    {
        self.persons_mocked = persons_mocked
        
        self.personService = PersonService_Mock(persons: persons_mocked)
    }
}
