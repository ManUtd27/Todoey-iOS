//
//  Item.swift
//  Todoey
//
//  Created by Shawn Williams on 10/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class Item: Encodable {
    var title: String = ""
    var done: Bool = false
}
