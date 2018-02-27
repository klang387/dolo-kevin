//
//  Location.swift
//  DoloChallenge
//
//  Created by Kevin Langelier on 2/26/18.
//  Copyright © 2018 Kevin Langelier. All rights reserved.
//

import Foundation

// Location model for each nearby location obtained from FourSquare

struct Location {
    let name: String
    let address: String
    let distance: Int
    let icon: String
    
    init(name: String, address: String, distance: Int, icon: String) {
        self.name = name
        self.address = address
        self.distance = distance
        self.icon = icon
    }
}
