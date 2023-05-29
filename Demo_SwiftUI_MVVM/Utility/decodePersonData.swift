//
//  decodePersonData.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


func decodePersonData
(
    _ data: Data
)
throws
-> [Person]
{
    do
    {
        let wrapper = try JSONDecoder().decode(PersonWrapper.self,
                                               from: data)
        
        let persons = wrapper.results
        
        return persons
    }
    catch let error as DecodingError
    {
        let detailedError = DetailedDecodingError(from: error)
        
        throw detailedError
    }
}
