//
//  Demo_SwiftUI_MVVMApp.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import SwiftUI

@main
struct Demo_SwiftUI_MVVMApp: App
{
    /*
     Dependencies are initialized and retained at the top level, the app.
     
     They are injected into the view tree via environment.
     */
    
    @State
    var dependencies: Dependencies = .init()
    
    
    
    var body: some Scene
    {
        WindowGroup
        {
            Persons.MainView()
                .environmentObject(dependencies)
        }
    }
}
