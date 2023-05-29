//
//  Persons.DetailView.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation
import SwiftUI


extension Persons
{
    struct DetailView: View
    {
        let viewModel: PersonViewModel
        
        
        var body: some View
        {
            VStack
            {
                Spacer()
                    .frame(height: 150)

                table
                
                Spacer()
                
                Button
                {
                    viewModel.toggleFavorite()
                }
                label:
                {
                    let imageName = viewModel.isFavorite ? "star.fill" : "star"
                    
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                }
                
                Spacer()
                    .frame(height: 50)
            }
        }
        
        
        private
        var table: some View
        {
            GeometryReader
            {
                reader in

                Grid(alignment: .top,
                     verticalSpacing: 10)
                {
                    ForEach(rows)
                    {
                        row in
                        
                        GridRow
                        {
                            Text(row.title + ":")
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .layoutPriority(2)
                                .gridColumnAlignment(.leading)
                            
                            Spacer()
                                .frame(width: 20)
                                .frame(height: 1)
                                .layoutPriority(2)
                            
                            Spacer()
                                .frame(minWidth: 0)
                                .frame(height: 1)
                                .layoutPriority(0)
                            
                            Text(row.value)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .layoutPriority(1)
                                .gridColumnAlignment(.trailing)
                        }
                    }
                }
                .frame(width: reader.size.width)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
        }
        
        
        private
        var rows: [Row]
        {
            let rowMapping: [(String, PartialKeyPath<Persons.PersonViewModel>)] =
                [
                    ("Name", \.displayName),
                    ("Street", \.street),
                    ("City", \.city),
                    ("Country", \.country),
                    ("Email", \.email),
                    ("Phone", \.phone),
                    ("Mobile", \.mobile)
                ]

            let rows =
                rowMapping
                    .map
                    {
                        Row(title: $0.0,
                            value: String(describing: self.viewModel[keyPath: $0.1]))
                    }
            
            return rows
        }
        
        
        private
        struct Row: Identifiable
        {
            let title: String
            
            let value: String
            
            var id: String { title }
        }
    }
}



// MARK: - Preview

struct Persons_DetailView_Previews: PreviewProvider
{
    static
    var previews: some View
    {
        let persons_mocked = try! MockData.persons1()

        
        Preview(persons_mocked: persons_mocked,
                person: persons_mocked[6])
            .previewDisplayName("person 6")

        
        Group
        {
            let person = Person(name: .init(title: "Mr",
                                            first: "Ihave",
                                            last: "Averylongnamethatisactuallyhardtofit"),
                                location: .init(street: .init(name: "Street",
                                                              number: 1),
                                                city: "City",
                                                country: "Verylongcountrynamethatisveryhardtofit"),
                                email: "a@b.c",
                                phone: "0123",
                                cell: "0123")

            Preview(persons_mocked: persons_mocked,
                    person: person)
        }
        .previewDisplayName("long / truncated")
    }
    
    
    @MainActor
    struct Preview: View
    {
        let viewModel: Persons.PersonViewModel
        
        
        init
        (
            persons_mocked: [Person],
            person: Person
        )
        {
            let dependencies_mocked = Dependencies_Mock(persons_mocked: persons_mocked)
            
            self.viewModel = Persons.PersonViewModel(from: person,
                                                     isFavorite: false,
                                                     dependencies: dependencies_mocked)
        }
        
        
        var body: some View
        {
            Persons.DetailView(viewModel: viewModel)
        }
    }
}

