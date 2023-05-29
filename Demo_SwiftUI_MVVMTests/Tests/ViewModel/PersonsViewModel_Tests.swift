//
//  PersonsViewModel_Tests.swift
//  Demo_SwiftUI_MVVMTests
//
//  Created by Stefan Ueter on 16.04.23.
//

import Foundation
@testable import Demo_SwiftUI_MVVM
import XCTest
import Combine


class PersonsViewModel_Tests: XCTestCase
{
    let persons_mocked = try! Array(MockData.persons1()[0...0])

    var dependencies_mocked: Dependencies_Mock!
    
    
    
    override
    func setUp()
    {
        self.dependencies_mocked = Dependencies_Mock(persons_mocked: persons_mocked)
    }
    
    
    override
    func tearDown()
    {
        self.dependencies_mocked = nil
    }
    
    
    
    // MARK: notLoaded
    
    @MainActor
    func test_notLoaded()
    {
        // arrange
        
        let sut_viewModel = Persons.ViewModel(dependencies: dependencies_mocked)
        
        
        // assert: state
        
        guard case .notLoaded = sut_viewModel.state
        else
        {
            XCTFail()
            return
        }
    }
    
    
    
    // MARK: loaded
    
    @MainActor
    func test_loaded() async throws
    {
        // arrange
        
        let sut_viewModel = Persons.ViewModel(dependencies: dependencies_mocked)
        let personService_mocked = self.dependencies_mocked.personService as! PersonService_Mock

        await personService_mocked.setLoadingDelay(.duration(.seconds(0.1)))
        
        let personViewModels_expected: [Persons.PersonViewModel] =
            [
                .init(from: self.persons_mocked[0],
                      isFavorite: true,
                      dependencies: self.dependencies_mocked)
            ]
        
        let favoritePersonIndex = 0
        
        let exp_notLoaded = XCTestExpectation(description: "notLoaded")
        let exp_loading = XCTestExpectation(description: "loading")
        let exp_loaded = XCTestExpectation(description: "loaded")
        let exp_favorited = XCTestExpectation(description: "favorited")

        var subscriptions = Set<AnyCancellable>()
        
        sut_viewModel.$state
            .sink
            {
                switch $0
                {
                    case .notLoaded:
                        
                        exp_notLoaded.fulfill()
                        
                    
                    case .loading:
                        
                        exp_loading.fulfill()
                        
                        
                    case .loaded(let personViewModels):
                        
                        exp_loaded.fulfill()
                        
                        let personViewModel_toBeFavorited = personViewModels[favoritePersonIndex]
                        
                        if personViewModel_toBeFavorited.isFavorite
                        {
                            exp_favorited.fulfill()
                        }
                        
                        
                    default:
                        
                        break
                }
            }
            .store(in: &subscriptions)
        
        
        
        // act: loadIfNeeded
        
        sut_viewModel.loadIfNeeded()

        
        
        // assert: .notLoaded -> .loading -> .loaded
        
        await self.fulfillment(of:
                                [
                                    exp_notLoaded,
                                    exp_loading,
                                    exp_loaded
                                ],
                               timeout: 2.0,
                               enforceOrder: true)
        
        guard case .loaded(let personViewModels_actual) = sut_viewModel.state
        else
        {
            XCTFail()
            return
        }
        

        
        // act: favorite person
        
        let personViewModel_favorite = personViewModels_actual[favoritePersonIndex]
        
        personViewModel_favorite.toggleFavorite()

        
        
        // assert: loaded PersonViewModels with favorite

        await self.fulfillment(of:
                                [
                                    exp_favorited
                                ],
                               timeout: 0.1)
        
        guard
            case .loaded(let personViewModels_actual) = sut_viewModel.state,
            personViewModels_actual.count == personViewModels_expected.count,
            try zip(personViewModels_actual, personViewModels_expected)
                .allSatisfy({
                    try equate_PersonViewModels(lhs: $0, rhs: $1, throw: true)
                })
        else
        {
            XCTFail()
            return
        }
    }
    
    

    // MARK: failed

    @MainActor
    func test_failed() async
    {
        // arrange

        let sut_viewModel = Persons.ViewModel(dependencies: dependencies_mocked)
        let personService_mocked = self.dependencies_mocked.personService as! PersonService_Mock

        await personService_mocked.setLoadingDelay(.duration(.seconds(0.1)))

        await personService_mocked.setFailure(DummyError(message: "failure"))

        let error_expected = await personService_mocked.failure

        let exp_notLoaded = XCTestExpectation(description: "notLoaded")
        let exp_loading = XCTestExpectation(description: "loading")
        let exp_failed = XCTestExpectation(description: "failed")

        var subscriptions = Set<AnyCancellable>()
        
        sut_viewModel.$state
            .sink
            {
                switch $0
                {
                    case .notLoaded:
                        
                        exp_notLoaded.fulfill()
                        
                    
                    case .loading:
                        
                        exp_loading.fulfill()
                        
                        
                    case .failed:
                        
                        exp_failed.fulfill()
                        
                        
                    default:
                        
                        break
                }
            }
            .store(in: &subscriptions)


        
        // act: loadIfNeeded

        sut_viewModel.loadIfNeeded()

        

        // assert: .notLoaded -> .loading -> .failed
        
        await self.fulfillment(of:
                                [
                                    exp_notLoaded,
                                    exp_loading,
                                    exp_failed
                                ],
                               timeout: 2.0,
                               enforceOrder: true)
        
        guard case .failed(let error_actual) = sut_viewModel.state,
              (error_expected as? DummyError) == (error_actual as? DummyError)
        else
        {
            XCTFail()
            return
        }
    }
}
