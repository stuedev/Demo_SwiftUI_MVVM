//
//  Persons.MainView.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation
import SwiftUI


extension Persons
{
    struct MainView: View
    {
        /*
         Dependencies are accessed via environment.
         
         They are injected into the content view via initializer instead of via environment, because they are needed in the initializer for the creation of the view model.
         
         Note: Dependencies are not observed by the view (no @Published properties).
         */
        
        @EnvironmentObject
        var dependencies: Dependencies
        
        
        var body: some View
        {
            ContentView(dependencies: self.dependencies)
        }
    }
}
