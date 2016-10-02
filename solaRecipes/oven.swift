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
    var _description: String?
    var _name: String?
    var _instructions: String?
    
    class func dynamoDBTableName() -> String {
        
        return "solarovenrecipes-mobilehub-1674615168-Ovens"
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
            "_description" : "description",
            "_name" : "name",
            "_instructions" : "instructions",
        ]
    }
}

