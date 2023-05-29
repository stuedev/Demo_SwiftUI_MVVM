//
//  Persons.ContentView.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation
import SwiftUI


extension Persons
{
    struct ContentView: View
    {
        /*
         The view model is created by the content view using the dependencies provided to the initializer.
         
         It is retained and observed by the content view.
         */
        
        @StateObject
        var viewModel: ViewModel

        
        
        init
        (
            dependencies: any DependenciesProtocol
        )
        {
            let viewModel = ViewModel(dependencies: dependencies)
            
            self._viewModel = StateObject(wrappedValue: viewModel)
        }
        
        
        
        var body: some View
        {
            VStack
            {
                switch self.viewModel.state
                {
                    case .notLoaded:
                        
                        loadButton
                        
                        
                    case .loading:
                        
                        loadingView
                        
                        
                    case .loaded(let personViewModels):
                        
                        personList(personViewModels)
                        
                        
                    case .failed(let error):
                        
                        errorView(error)
                }
            }
        }
        
        
        private
        var loadButton: some View
        {
            Button("load")
            {
                self.viewModel.loadIfNeeded()
            }
        }
        
        
        private
        var loadingView: some View
        {
            ProgressView()
        }
        
        
        private
        func personList
        (
            _ viewModels: [Persons.PersonViewModel]
        )
        -> some View
        {
            ListView(viewModels: viewModels)
        }
        
        
        private
        func errorView
        (
            _ error: Error
        )
        -> some View
        {
            Text(error.localizedDescription)
                .foregroundColor(.red)
        }
    }
}



// MARK: - Previews

struct Persons_ContentView_Previews: PreviewProvider
{
    static
    var previews: some View
    {
        let persons_mocked = try! MockData.persons1()

        
        Preview(persons_mocked: persons_mocked)
            .previewDisplayName("not loaded")
        
        
        Preview(persons_mocked: persons_mocked)
        {
            await $0.setLoadingDelay(.infinite)

            await $0.loadIfNeeded()
        }
        .previewDisplayName("loading")


        Preview(persons_mocked: persons_mocked)
        {
            await $0.loadIfNeeded()
        }
        .previewDisplayName("loaded")


        Preview(persons_mocked: persons_mocked)
        {
            await $0.setFailure(DummyError(message: "Some error has occurred."))

            await $0.loadIfNeeded()
        }
        .previewDisplayName("failed")
    }
    
    
    @MainActor
    struct Preview: View
    {
        /*
         A preview wrapper creates an instance of mocked dependencies and retains it.
         */
        
        @State
        var dependencies_mocked: any DependenciesProtocol
        
        
        init
        (
            persons_mocked: [Person],
            setup: @Sendable @escaping (PersonService_Mock) async -> Void = { _ in }
        )
        {
            let dependencies_mocked = Dependencies_Mock(persons_mocked: persons_mocked)
            self._dependencies_mocked = State(wrappedValue: dependencies_mocked)
            
            
            // setup
            
            Task
            {
                let personService_mocked = dependencies_mocked.personService as! PersonService_Mock
                
                await setup(personService_mocked)
            }
        }
        
        
        var body: some View
        {
            Persons.ContentView(dependencies: dependencies_mocked)
        }
    }
}

