//
//  Persons.PersonViewModel.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


/*
 A child view model representing a Person.
 */

extension Persons
{
    struct PersonViewModel: Identifiable
    {
        // config
        
        let dependencies: any DependenciesProtocol
        
        var personService: PersonServiceProtocol
        {
            self.dependencies.personService
        }
        
        
        
        // members

        let id: UUID

        let displayName: String
        
        let street: String
        
        let city: String
        
        let country: String
        
        let email: String
        
        let phone: String

        let mobile: String
        
        let isFavorite: Bool

        

        // init
        
        init
        (
            from person: Person,
            isFavorite: Bool,
            dependencies: any DependenciesProtocol
        )
        {
            self.dependencies = dependencies

            self.id = person.id
            self.displayName = person.name.title + " " + person.name.first + " " + person.name.last
            self.street = person.location.street.name + " " + String(person.location.street.number)
            self.city = person.location.city
            self.country = person.location.country
            self.email = person.email
            self.phone = person.phone
            self.mobile = person.cell
            self.isFavorite = isFavorite
        }
        
        
        
        // commands
        
        func toggleFavorite()
        {
            Task
            {
                await self.personService.toggleFavorite(personID: self.id)
            }
        }
    }
}
