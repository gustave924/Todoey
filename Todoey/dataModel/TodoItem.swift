//
//  TodoItem.swift
//  Todoey
//
//  Created by Ahmed Aboelela on 7/6/19.
//  Copyright © 2019 Ahmed Aboelela. All rights reserved.
//

import Foundation

class TodoItem{
    var itemValue : String
    var isChecked : Bool

    init(itemValue: String, isChecked: Bool){
        self.itemValue = itemValue
        self.isChecked = isChecked
    }

}
