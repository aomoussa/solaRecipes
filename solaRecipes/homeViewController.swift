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
    @IBOutlet weak var ovenTableView: UITableView!
    
    @IBOutlet weak var recipeTableView: UITableView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var recies = [recipe]()
    var ovens = [oven]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        
        ovenTableView.delegate = self
        ovenTableView.dataSource = self
        
        queryRecipeData()
        ovenTableView.isHidden = true
        recipeTableView.isHidden = false
    }
    func getSegmentedControlState(sc: UISegmentedControl) -> String{
        switch(sc.selectedSegmentIndex){
        case 1:
            return "ovens"
        default:
            return "recipes"
        }
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch(getSegmentedControlState(sc: sender)){
        case "ovens":
            queryOvenData()
            ovenTableView.isHidden = false
            recipeTableView.isHidden = true
            break
        default:
            queryRecipeData()
            ovenTableView.isHidden = true
            recipeTableView.isHidden = false
            break
        }
    }
    func queryRecipeData(){
        self.recies.removeAll()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.limit = 100;
        dynamoDBObjectMapper.scan(recipe.self, expression: queryExpression).continue({ (task:AWSTask!) -> AnyObject! in
            
            print("task result is \(task.result)")
            if task.result != nil {
                
                let paginatedOutput = task.result as? AWSDynamoDBPaginatedOutput!
                
                for item in paginatedOutput?.items as! [recipe] {
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
    func queryOvenData(){
        self.ovens.removeAll()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.limit = 100;
        dynamoDBObjectMapper.scan(oven.self, expression: queryExpression).continue({ (task:AWSTask!) -> AnyObject! in
            
            print("task result is \(task.result)")
            if task.result != nil {
                
                let paginatedOutput = task.result as? AWSDynamoDBPaginatedOutput!
                
                for item in paginatedOutput?.items as! [oven] {
                    //NSLog(item.M!.stringValue)
                    self.ovens.append(item)
                    self.ovenTableView.reloadData()
                    print("self.ovens.count: \(self.ovens.count)")
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
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(tableView){
        case ovenTableView:
            return ovens.count
        default:
            return recies.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch(tableView){
        case ovenTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ovenCell", for: indexPath)
            cell.textLabel?.text = ovens[(indexPath as NSIndexPath).row]._name
            cell.detailTextLabel?.text = ovens[(indexPath as NSIndexPath).row]._description
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
            cell.textLabel?.text = recies[(indexPath as NSIndexPath).row]._name
            cell.detailTextLabel?.text = recies[(indexPath as NSIndexPath).row]._description
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(tableView){
        case ovenTableView:
            queryOvenData()
            break
        default:
            queryRecipeData()
            break
        }
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
