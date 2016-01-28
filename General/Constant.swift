//
//  Constant.swift
//  Smartshop
//
//  Created by Shunchao Wang on 1/26/2016.
//  Copyright © 2016 swang. All rights reserved.
//

class Constant {
    
    class var ServiceUrl: String {
        return "https://localhost:7443"
    }
    
    class var ZencartUrl: String {
        return "http://localhost/zencart/images"
    }
    
    class var AllCategoryRequest: String {
        return "category/query"
    }
    
    class var ProductByCategoryRequest: String {
        return "/category/products"
    }
    
    class var PageLimit: Int {
        return 20
    }
}
