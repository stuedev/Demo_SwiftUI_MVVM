//
//  PersonService_Tests.swift
//  Demo_SwiftUI_MVVMTests
//
//  Created by Stefan Ueter on 20.04.23.
//

import Foundation
import XCTest
@testable import Demo_SwiftUI_MVVM
import Combine


class PersonService_Tests: XCTestCase
{
    @ServiceActor
    func test_loaded_favorited() async
    {
        // arrange

        let sut_personService = PersonService()

        let favoritePersonIndex = 0
        
        let exp_notLoaded = XCTestExpectation(description: "notLoaded")
        let exp_loading = XCTestExpectation(description: "loading")
        let exp_loaded = XCTestExpectation(description: "loaded")
        let exp_favorited = XCTestExpectation(description: "favorited")
        
        var subscriptions = Set<AnyCancellable>()
        
        sut_personService.personsStatePublisher
            .combineLatest(sut_personService.favoritesPublisher)
            .sink
            {
                let personsState = $0.0
                let favoritesState = $0.1
                
                switch personsState
                {
                    case .notLoaded:
                        
                        exp_notLoaded.fulfill()
                    
                    
                    case .loading:
                        
                        exp_loading.fulfill()
                    
                    
                    case .loaded(let persons):
                        
                        exp_loaded.fulfill()
                        
                        if favoritesState.contains(persons[favoritePersonIndex].id)
                        {
                            exp_favorited.fulfill()
                        }

                        
                    default:
                        
                        break
                }
            }
            .store(in: &subscriptions)

        
        
        // act: loadIfNeeded
        
        sut_personService.loadIfNeeded()

        
        
        // assert: .notLoaded -> .loading -> .loaded
        
        await self.fulfillment(of:
                                [
                                    exp_notLoaded,
                                    exp_loading,
                                    exp_loaded
                                ],
                               timeout: 2.0,
                               enforceOrder: true)      // 2.0 sec because of fake delay
        
        guard case .loaded(let persons) = sut_personService.personsState
        else
        {
            XCTFail()
            return
        }
        
        
        
        // act: toggleFavorite
        
        sut_personService.toggleFavorite(personID: persons[favoritePersonIndex].id)
        
        
        
        // assert: favorited
        
        await self.fulfillment(of:
                                [
                                    exp_favorited
                                ],
                               timeout: 0.1)
        
        guard sut_personService.favorites.contains(persons[favoritePersonIndex].id)
        else
        {
            XCTFail()
            return
        }
    }
}
