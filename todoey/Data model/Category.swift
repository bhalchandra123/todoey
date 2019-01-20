//
//  Category.swift
//  todoey
//
//  Created by bhalchandra on 05/01/19.
//  Copyright © 2019 bhalchandra. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
