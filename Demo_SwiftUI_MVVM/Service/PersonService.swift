//
//  PersonService.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation
import Combine


/*
 As defined in the protocol, `PersonService` is isolated to the `ServiceActor` global actor.
 */

class PersonService: PersonServiceProtocol
{
    // static

    static
    let numberOfPersons = 10

    static
    let fakeLoadingTime: TimeInterval = 1.0
    
    

    // config
    
    lazy var session: URLSession =
    {
        let session = URLSession(configuration: self.sessionConfiguration)

        return session
    }()
    
    
    var sessionConfiguration: URLSessionConfiguration
    {
        let configuration = URLSessionConfiguration.default
        
        /*
         Mocked Network flag to be used in unit tests
         */
        
        if ProcessInfo.processInfo.arguments.contains("mockedNetwork")
        {
            configuration.protocolClasses = [URLProtocol_Mock.self]
        }
        
        return configuration
    }



    // state
    
    var personsStatePublisher: CurrentValueSubject<LoadableState<[Person]>, Never> = .init(.notLoaded)
    
    var favoritesPublisher: CurrentValueSubject<Set<UUID>, Never> = .init([])
    
    
    
    // init
    
    nonisolated
    init()
    {
    }
    
    
    
    // functionality

    func load()
    {
        Task
        {
            do
            {
                let persons = try await self.loadPersons(count: Self.numberOfPersons)
                
                self.personsState = .loaded(persons)
            }
            catch
            {
                self.personsState = .failed(error)
            }
        }
    }
    
    
    private
    func loadPersons
    (
        count: Int
    )
    async
    throws
    -> [Person]
    {
        let url = try Self.createURL(count: count)
        let request = URLRequest(url: url)
        
        /*
         `URLSession.data(for: URLRequest)` is dispatching its work to a background thread internally.
         
         The warning here (as of Xcode 14.3) appears to be a compiler bug:
         https://forums.swift.org/t/are-existential-types-sendable/58946/4
         */
        
        let result = try await self.session.data(for: request)
        
        let data = result.0
        let persons = try decodePersonData(data)
        
        /*
         fake loading time for UI experience (loading indicator)
         */
        
        try await Task.sleep(for: .seconds(Self.fakeLoadingTime))
        
        return persons
    }
    
    
    private
    static
    func createURL
    (
        count: Int
    )
    throws
    -> URL
    {
        let baseURLString = "https://randomuser.me/api"
        
        var components = try URLComponents(string: baseURLString)   ?! "failed to create URL components"        // see throwIfNil.swift
        
        let resultsItem = URLQueryItem(name: "results",
                                       value: "\(count)")
        
        components.queryItems = [resultsItem]
        
        let url = try components.url    ?! "failed to create URL"
        
        return url
    }
}
