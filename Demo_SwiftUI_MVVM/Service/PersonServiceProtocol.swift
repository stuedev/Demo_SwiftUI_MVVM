//
//  PersonServiceProtocol.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation
import Combine


/**
 The `ServiceActor` global actor can be used to allow safe actor boundary crossing of (non-sendable) publisher properties of the PersonServiceProtocol.
 
 Example:
 
 ```
 Task
 {
    @ServiceActor in
 
    service.personsStatePublisher
        .sink
        {
            ...
        }
 }
 
 ```
 */
@globalActor
struct ServiceActor
{
    actor Actor {}
    
    
    static
    let shared: Actor = .init()
}



/*
 The protocol is marked with @ServiceActor, which means that all adopting types will be isolated to that actor.
 */

@ServiceActor
protocol PersonServiceProtocol: AnyObject, Sendable
{
    var personsStatePublisher: CurrentValueSubject<LoadableState<[Person]>, Never> { get }

    var favoritesPublisher: CurrentValueSubject<Set<UUID>, Never> { get }
    

    func load()
}


extension PersonServiceProtocol
{
    var personsState: LoadableState<[Person]>
    {
        get
        {
            personsStatePublisher.value
        }
        
        set
        {
            personsStatePublisher.send(newValue)
        }
    }

    
    var favorites: Set<UUID>
    {
        get
        {
            favoritesPublisher.value
        }
        
        set
        {
            favoritesPublisher.send(newValue)
        }
    }

    
    func loadIfNeeded()
    {
        guard case .notLoaded = self.personsState
        else
        {
            return
        }
        
        self.personsState = .loading
        
        self.load()
    }
    
    
    func toggleFavorite
    (
        personID: UUID
    )
    {
        if self.favorites.contains(personID)
        {
            self.favorites.remove(personID)
        }
        else
        {
            self.favorites.insert(personID)
        }
    }
}
