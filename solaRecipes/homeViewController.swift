//
//  homeViewController.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 9/13/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit
import AWSDynamoDB

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeTableView: UITableView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var recies = [recipe]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //recies.append(recipe(title: "pizza", temp: "300F", instructions: "step 1: bake pizza, step 2: eat pizza"))
        //recies.append(recipe(title: "pasta", temp: "1200F", instructions: "step 1: bake pasta, step 2: eat pasta"))
        //recies.append(recipe(title: "koshary", temp: "90F", instructions: "step 1: bake koshary, step 2: eat koshary"))
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        
        queryRecipeData()
    }
    func queryRecipeData(){
        self.recies.removeAll()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.limit = 100;
        dynamoDBObjectMapper.scan(recipe.self, expression: queryExpression).continueWithBlock({ (task:AWSTask!) -> AnyObject! in
            
            print("task result is \(task.result)")
            if task.result != nil {
                
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                
                for item in paginatedOutput.items as! [recipe] {
                    //NSLog(item.M!.stringValue)
                    self.recies.append(item)
                    self.recipeTableView.reloadData()
                    print("self.recies.count: \(self.recies.count)")
                }
                
                if ((task.error) != nil) {
                    print("Error: \(task.error)")
                }
                return nil
                
            }
            
            
            return nil
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // ---------------- --------------- table view code
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recies.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = recies[indexPath.row]._name
        cell.detailTextLabel?.text = recies[indexPath.row]._description
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        queryRecipeData()
    }

    
    // ---------------- --------------- table view code
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
