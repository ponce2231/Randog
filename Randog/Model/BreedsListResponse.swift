//
//  BreedsListResponse.swift
//  Randog
//
//  Created by Christopher Ponce Mendez on 8/18/19.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation
struct BreedsListResponse: Codable {
    let status: String
    let message: [String : [String]]
}
