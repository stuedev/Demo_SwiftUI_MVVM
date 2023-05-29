//
//  Dependencies.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


/*
 Subclasses `ObservableObject` because it's used with @EnvironmentObject, not because it should be observed by the views.
 
 Individual dependencies, i.e. Services, are observed by view models.
 */

class Dependencies: ObservableObject, DependenciesProtocol
{
    let personService: PersonServiceProtocol = PersonService()
}
