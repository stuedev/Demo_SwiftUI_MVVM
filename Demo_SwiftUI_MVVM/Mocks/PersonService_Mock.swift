//
//  PersonService_Mock.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation
import Combine


/*
 As defined in the protocol, `PersonService` is isolated to the `ServiceActor` global actor.
 */

class PersonService_Mock: PersonServiceProtocol
{
    // config
    
    let persons: [Person]
    
    
    
    // state

    private(set)
    var failure: Error?

    private(set)
    var loadingDelay: LoadingDelay = .none

    var personsStatePublisher: CurrentValueSubject<LoadableState<[Person]>, Never> = .init(.notLoaded)
    
    var favoritesPublisher: CurrentValueSubject<Set<UUID>, Never> = .init([])

    

    
    // init
    
    nonisolated
    init
    (
        persons: [Person]
    )
    {
        self.persons = persons
    }
    
    
    
    // functionality
    
    func load()
    {
        Task
        {
            switch self.loadingDelay
            {
                case .none:
                    
                    break
                    
                    
                case .duration(let duration):
                    
                    try! await Task.sleep(for: duration)
                    
                    
                case .infinite:
                    
                    return
            }
            
            switch self.failure
            {
                case .none:
                    
                    self.personsState = .loaded(self.persons)
                    
                    
                case .some(let error):
                    
                    self.personsState = .failed(error)
            }
        }
    }
    
    
    func setFailure
    (
        _ failure: Error
    )
    {
        self.failure = failure
    }
    
    
    func setLoadingDelay
    (
        _ delay: LoadingDelay
    )
    {
        self.loadingDelay = delay
    }
    
    
    
    enum LoadingDelay
    {
        case none
        
        case duration(Duration)
        
        case infinite
    }
}

