//
//  oven.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 10/2/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB

class oven: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _id: String?
    var _name: String?
    var _description: String?
    var _instructions: String?
    var _userID: String?
    
    class func dynamoDBTableName() -> String {
        
        return "solarrecipes-mobilehub-623139932-Oven"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_id"
    }
    
    class func rangeKeyAttribute() -> String {
        
        return "_name"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_id" : "id",
            "_name" : "name",
            "_description" : "description",
            "_instructions" : "instructions",
            "_userID" : "userID",
        ]
    }
}
