//
//  URLProtocol_Mock.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


class URLProtocol_Mock: URLProtocol
{
    override
    static
    func canInit
    (
        with request: URLRequest
    )
    -> Bool
    {
        true
    }
    
    
    override
    static
    func canonicalRequest
    (
        for request: URLRequest
    )
    -> URLRequest
    {
        request
    }
    
    
    override
    func startLoading()
    {
        let data = MockData.persons1_raw.data(using: .utf8)
        
        let response = HTTPURLResponse(url: self.request.url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        client!.urlProtocol(self,
                            didReceive: response!,
                            cacheStoragePolicy: .notAllowed)
        
        client!.urlProtocol(self,
                            didLoad: data!)
        
        client!.urlProtocolDidFinishLoading(self)
    }
    
    
    override
    func stopLoading()
    {
    }
}
