//
//  LoadableState.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


enum LoadableState<T: Sendable>
{
    case notLoaded
    
    case loading
    
    case loaded(T)
    
    case failed(Error)
}
