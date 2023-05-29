//
//  Persons.ContentView.ListView.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation
import SwiftUI


extension Persons.ContentView
{
    struct ListView: View
    {
        let viewModels: [Persons.PersonViewModel]
        
        
        var body: some View
        {
            NavigationView
            {
                List(viewModels)
                {
                    viewModel in
                    
                    NavigationLink
                    {
                        Persons.DetailView(viewModel: viewModel)
                    }
                    label:
                    {
                        PersonCell(viewModel: viewModel)
                    }
                }
            }
        }
        
        
        private
        struct PersonCell: View
        {
            let viewModel: Persons.PersonViewModel
            
            
            var body: some View
            {
                HStack
                {
                    Text(self.viewModel.displayName)
                    
                    Spacer(minLength: 20)

                    let imageName = viewModel.isFavorite ? "star.fill" : "star"

                    Image(systemName: imageName)
                        .onTapGesture
                        {
                            self.viewModel.toggleFavorite()
                        }
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}



// MARK: - Previews

struct Persons_ContentView_ListView_Previews: PreviewProvider
{
    static
    var previews: some View
    {
        let persons_mocked1 = try! MockData.persons1()
        
        Preview(persons_mocked: persons_mocked1)
            .previewDisplayName("persons1")

        
        let persons_mocked2 = try! MockData.persons2()
        
        Preview(persons_mocked: persons_mocked2)
            .previewDisplayName("persons2")
    }
    
    
    @MainActor
    struct Preview: View
    {
        let viewModels: [Persons.PersonViewModel]
        
        
        init
        (
            persons_mocked: [Person]
        )
        {
            let dependencies_mocked = Dependencies_Mock(persons_mocked: persons_mocked)

            self.viewModels =
                persons_mocked
                    .map
                    {
                        Persons.PersonViewModel(from: $0,
                                                isFavorite: false,
                                                dependencies: dependencies_mocked)
                    }
        }


        var body: some View
        {
            Persons.ContentView.ListView(viewModels: self.viewModels)
        }
    }
}
