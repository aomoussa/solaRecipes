//
//  Users.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.3
//

import Foundation
import UIKit
import AWSDynamoDB

class Users: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _name: String?
    var _description: String?
    var _recipes: Set<NSNumber>?
    
    class func dynamoDBTableName() -> String {

        return "solarovenrecipes-mobilehub-1674615168-Users"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_name"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_name" : "name",
               "_description" : "description",
               "_recipes" : "recipes",
        ]
    }
}
