//
//  EvenResult.swift
//  isEven
//
//  Created by Paulo Atavila on 28/05/21.
//

import Foundation

struct EvenResult: Decodable {
    let isEven: Bool
    let advertising: String
    
    enum CodingKeys: String, CodingKey {
        case isEven = "iseven"
        case advertising = "ad"
    }
}
