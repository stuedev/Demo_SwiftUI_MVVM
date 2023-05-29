//
//  Person.swift
//  Demo_SwiftUI_MVVM
//
//  Created by Stefan Ueter on 29.05.23.
//

import Foundation


struct Person: Decodable
{
    let id: UUID = .init()
    
    
    enum CodingKeys: CodingKey
    {
        case name

        case location

        case email

        case phone

        case cell
    }
    
    
    let name: Name
    
    let location: Location
    
    let email: String
    
    let phone: String
    
    let cell: String
}


extension Person
{
    struct Name: Decodable
    {
        let title: String
        
        let first: String
        
        let last: String
    }
    
    
    struct Location: Decodable
    {
        let street: Street
        
        let city: String
        
        let country: String
    }
    
    
    struct Street: Decodable
    {
        let name: String
        
        let number: Int
    }
}



/*
 Example:
 
 {
       "gender": "female",
       "name": {
         "title": "Miss",
         "first": "Jennie",
         "last": "Nichols"
       },
       "location": {
         "street": {
           "number": 8929,
           "name": "Valwood Pkwy",
         },
         "city": "Billings",
         "state": "Michigan",
         "country": "United States",
         "postcode": "63104",
         "coordinates": {
           "latitude": "-69.8246",
           "longitude": "134.8719"
         },
         "timezone": {
           "offset": "+9:30",
           "description": "Adelaide, Darwin"
         }
       },
       "email": "jennie.nichols@example.com",
       "login": {
         "uuid": "7a0eed16-9430-4d68-901f-c0d4c1c3bf00",
         "username": "yellowpeacock117",
         "password": "addison",
         "salt": "sld1yGtd",
         "md5": "ab54ac4c0be9480ae8fa5e9e2a5196a3",
         "sha1": "edcf2ce613cbdea349133c52dc2f3b83168dc51b",
         "sha256": "48df5229235ada28389b91e60a935e4f9b73eb4bdb855ef9258a1751f10bdc5d"
       },
       "dob": {
         "date": "1992-03-08T15:13:16.688Z",
         "age": 30
       },
       "registered": {
         "date": "2007-07-09T05:51:59.390Z",
         "age": 14
       },
       "phone": "(272) 790-0888",
       "cell": "(489) 330-2385",
       "id": {
         "name": "SSN",
         "value": "405-88-3636"
       },
       "picture": {
         "large": "https://randomuser.me/api/portraits/men/75.jpg",
         "medium": "https://randomuser.me/api/portraits/med/men/75.jpg",
         "thumbnail": "https://randomuser.me/api/portraits/thumb/men/75.jpg"
       },
       "nat": "US"
     }
 */
