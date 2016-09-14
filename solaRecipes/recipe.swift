//
//  File.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 9/13/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import Foundation

class recipe{
    var title: String
    var temp: String
    var instructions: String
    
    init(title: String, temp: String, instructions: String){
        self.title = title
        self.temp = temp
        self.instructions = instructions
    }
    init(){
        title = "sample recipe"
        temp = "140F"
        instructions = "why do birds suddenly appear, everytime you are near? just like me, they long to be close to you! :("
    }
}