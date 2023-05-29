//
//  Persons.ViewModel.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation
import Combine


extension Persons
{
    /*
     The main view model for the `Persons` domain.
     */
    
    @MainActor
    class ViewModel: ObservableObject
    {
        /*
         View model references the model layer (service) and observes it's changes.
         */
        
        
        // config
        
        private
        let dependencies: any DependenciesProtocol
        
        private
        var personService: PersonServiceProtocol
        {
            self.dependencies.personService
        }
        
        
        // state
        
        @Published
        var state: LoadableState<[PersonViewModel]> = .notLoaded
        
        @ServiceActor   // TODO: Workaround. Try to find a better, more elegant solution.
        private
        var subscriptions: Set<AnyCancellable> = .init()
        
        
        
        // init
        
        init
        (
            dependencies: any DependenciesProtocol
        )
        {
            self.dependencies = dependencies
            
            
            /*
             Observe service's published properties to call `update`.

             We move onto the ServiceActor's executor to safely access the service's (non-sendable) publishers.
             */

            Task
            {
                @ServiceActor in
                
                await personService.personsStatePublisher
                    .combineLatest(personService.favoritesPublisher)
                    .sink
                    {
                        let personsState = $0.0
                        let favoriteState = $0.1
                        
                        
                        /*
                         Now, we move back onto the MainActor's executor to update our state.
                         */
                        
                        Task
                        {
                            @MainActor in
                            
                            self.update(personsState,
                                        favoriteState)
                        }
                    }
                    .store(in: &self.subscriptions)
            }
        }

        
        
        // commands
        
        func loadIfNeeded()
        {
            Task
            {
                await self.personService.loadIfNeeded()
            }
        }


        
        // functions
        
        private
        func update
        (
            _ personsState: LoadableState<[Person]>,
            _ favorites: Set<UUID>
        )
        {
            switch personsState
            {
                case .notLoaded:
                    
                    self.state = .notLoaded
                    
                    
                case .loading:
                    
                    self.state = .loading
                    
                    
                case .loaded(let personModels):
                    
                    let personViewModels = self.createPersonViewModels(from: personModels,
                                                                       favorites: favorites)
                    
                    self.state = .loaded(personViewModels)
                    
                    
                case .failed(let error):
                    
                    self.state = .failed(error)
            }
        }
        
        
        private
        func createPersonViewModels
        (
            from personModels: [Person],
            favorites: Set<UUID>
        )
        -> [PersonViewModel]
        {
            personModels
                .map
                {
                    person in
                    
                    .init(from: person,
                          isFavorite: favorites.contains { $0 == person.id },
                          dependencies: self.dependencies)
                }
        }
    }
}
