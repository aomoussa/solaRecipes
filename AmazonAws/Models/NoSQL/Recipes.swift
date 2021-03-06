//
//  File.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 9/13/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//
//
//  Recipes.swift
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

class DBRecipe: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _id: String?
    var _name: String?
    var _description: String?
    var _duration: NSNumber?
    var _instructions: String?
    var _numberOfPictures: NSNumber?
    var _temperature: NSNumber?
    var _creatorFBID: String?
    var _creatorName: String?
    
    class func dynamoDBTableName() -> String {
        
        return "solarrecipes-mobilehub-623139932-Recipe"
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
            "_duration" : "duration",
            "_instructions" : "instructions",
            "_numberOfPictures" : "numberOfPictures",
            "_temperature" : "temperature",
            "_creatorFBID" : "creatorFBID",
            "_creatorName" : "creatorName",
            
        ]
    }
}

