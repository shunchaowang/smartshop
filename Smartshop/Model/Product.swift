//
//  Product.swift
//  Smartshop
//
//  Created by Shunchao Wang on 1/26/2016.
//  Copyright © 2016 swang. All rights reserved.
//

import Foundation

struct Category {
    var id: Int
    var name: String
    var image: String
}

struct Product {
    var id: Int
    var model: String
    var quantity: Int
    var image: String
    var price: Double
    var weight: Double
    var name: String
    var description: String
    var categoryId: Int
}
