//
//  DependenciesProtocol.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


protocol DependenciesProtocol: ObservableObject
{
    var personService: PersonServiceProtocol { get }
}
