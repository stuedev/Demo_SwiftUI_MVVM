//
//  DetailedDecodingError.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


struct DetailedDecodingError: LocalizedError
{
    let detailedErrorMessage: String
    
    var errorDescription: String?
    {
        detailedErrorMessage
    }


    
    init
    (
        from error: DecodingError
    )
    {
        switch error
        {
            case .typeMismatch(let type, let context):
                
                let contextString = Self.stringForContext(context)
                self.detailedErrorMessage = "mismatched type `\(type)`, context: \(contextString)"

                
            case .keyNotFound(let key, let context):

                let contextString = Self.stringForContext(context)
                self.detailedErrorMessage = "key not found `\(key)`, context: \(contextString)"
                
                
            case .valueNotFound(let type, let context):

                let contextString = Self.stringForContext(context)
                self.detailedErrorMessage = "value not found for type `\(type)`, context: \(contextString)"
                
                
            case .dataCorrupted(let context):

                let contextString = Self.stringForContext(context)
                self.detailedErrorMessage = "data corrupted, context: \(contextString)"
            
            
            @unknown default:
                
                self.detailedErrorMessage = "<case not implemented: `\(error)`>"
        }
    }
    
    
    private
    static
    func stringForContext
    (
        _ context: DecodingError.Context
    )
    -> String
    {
        let components: [(String, Any?)] =
            [
                ("codingPath", stringForCodingPath(context.codingPath)),
                ("debugDescription", context.debugDescription),
                ("underlyingError", context.underlyingError?.localizedDescription)
            ]

        let string =
            components
                .compactMap
                {
                    guard let value = $0.1
                    else
                    {
                        return nil
                    }
                    
                    return $0.0 + " = " + "\"" + String(describing: value) + "\""
                }
                .joined(separator: ", ")
        
        return "[" + string + "]"
    }
    
    
    private
    static
    func stringForCodingPath
    (
        _ codingPathComponents: [CodingKey]
    )
    -> String
    {
        codingPathComponents
            .map
            {
                if let intValue = $0.intValue
                {
                    return String(describing: intValue)
                }
                else
                {
                    return $0.stringValue
                }
            }
            .joined(separator: "/")
    }
}
