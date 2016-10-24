//
//  searchViewController.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 10/17/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class searchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var recies = [recipe]()
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var advancedSearchDuration = 10
    var advancedSearchWeight = 10
    var advancedSearchFromTemp = 20
    var advancedSearchToTemp = 100
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        searchBar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(filterName: String, completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: Error?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#id = :id AND #name = :name"
        queryExpression.expressionAttributeNames = [
            "#id": "id",
            "#name": "name",
        ]
        queryExpression.expressionAttributeValues = [
            ":id": "0",
            ":name": filterName,
        ]
        
        
        objectMapper.query(DBRecipe.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error)
                
            })
        })
    }
    func queryRecipesBeginWithNameWithCompletionHandler(filterName: String, completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: Error?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "begins_with(#name, :name)"
        queryExpression.expressionAttributeNames = [
            "#name": "name"
        ]
        queryExpression.expressionAttributeValues = [
            ":name": filterName
        ]
        
        
        objectMapper.query(DBRecipe.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error)
                
            })
        })
    }
    func newScanWithFilterNameAndCompletionHandler(filterName: String, completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: Error?) -> Void) {
        self.recies.removeAll()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "begins_with(#name, :name)"
        scanExpression.expressionAttributeNames = [
            "#name": "name"
        ]
        scanExpression.expressionAttributeValues = [
            ":name": filterName
        ]
        
        scanExpression.limit = 10;
        dynamoDBObjectMapper.scan(DBRecipe.self, expression: scanExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error)
                
            })
        })
    }
    func scanRecipeData(scanExpression: String){
        self.recies.removeAll()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "#description < :description"
        scanExpression.expressionAttributeNames = ["#description": "description" ,]
        scanExpression.expressionAttributeValues = [":description": scanExpression ,]
        
        scanExpression.limit = 10;
        dynamoDBObjectMapper.scan(DBRecipe.self, expression: scanExpression).continue({ (task:AWSTask!) -> AnyObject! in
            
            print("task result is \(task.result)")
            if task.result != nil {
                
                let paginatedOutput = task.result as? AWSDynamoDBPaginatedOutput!
                
                var i = 0
                for item in paginatedOutput?.items as! [DBRecipe] {
                    //NSLog(item.M!.stringValue)
                    let newRecie = recipe(recip: item)
                    self.recies.append(newRecie)
                    DispatchQueue.main.async(execute: {
                        self.searchResultsTableView.reloadData()
                        print(self.recies)
                        i = i + 1
                    })
                    
                }
                
                if ((task.error) != nil) {
                    print("Error: \(task.error)")
                }
                return nil
                
            }
            
            
            return nil
        })
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var scanExpression = "Fresh off the boatt"
        
        scanExpression = searchBar.text!
        //scanRecipeData(scanExpression: scanExpression)
        let completionHandler = {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            if let error = error {
                var errorMessage = "Failed to retrieve items. \(error.localizedDescription)"
                //if (error. == AWSServiceErrorDomain && error.code == AWSServiceErrorType.accessDeniedException.rawValue) {
                 //   errorMessage = "Access denied. You are not allowed to perform this operation."
                //}
                self.showAlertWithTitle(title: "Error", message: errorMessage)
            }
            else if response!.items.count == 0 {
                self.showAlertWithTitle(title: "Not Found", message: "No items match your criteria. Insert more sample data and try again.")
            }
            else {
                //it all worked out:
                let paginatedOutput = response as? AWSDynamoDBPaginatedOutput!
                
                var i = 0
                for item in paginatedOutput?.items as! [DBRecipe] {
                    //NSLog(item.M!.stringValue)
                    let newRecie = recipe(recip: item)
                    self.recies.append(newRecie)
                    self.searchResultsTableView.reloadData()
                    print(self.recies)
                    i = i + 1
                    
                }
                
            }
            
        }
        newScanWithFilterNameAndCompletionHandler(filterName: scanExpression, completionHandler: completionHandler )
        self.view.endEditing(true)
    }
    // ---------------- --------------- table view code
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //switch(tableView){
        //case ovenTableView:
        //    return ovens.count
        //default:
        if(section == 0){
            return 1
        }
        return recies.count
        //}
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*switch(tableView){
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
         */
        if(indexPath.section == 0){
            //return makeAdvancedSearchCell(indexPath: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "advancedSearchCell") as! advancedSearchTableViewCell
            cell.fromTempTextField.text = "\(advancedSearchFromTemp)F"
            cell.toTempTextField.text = "\(advancedSearchToTemp)F"
            cell.fromTempTextField.delegate = self
            cell.toTempTextField.delegate = self
            
            cell.durationSlider.value = Float(advancedSearchDuration)
            cell.weightSlider.value = Float(advancedSearchWeight)
            cell.durationLabel.text = "\(advancedSearchDuration) mins"
            cell.weightLabel.text = "\(advancedSearchWeight) lbs"
            
            cell.durationSlider.addTarget(self, action:  #selector(searchViewController.durationSliderChanged(_:)), for: UIControlEvents.valueChanged)
            cell.weightSlider.addTarget(self, action: #selector(searchViewController.weightSliderChanged(_:)), for: UIControlEvents.valueChanged
            )
            return cell
        }
        else{
            return makeRecipeCell(indexPath: indexPath)
        }
        //}
    }
    func durationSliderChanged(_ sender: UISlider){
        advancedSearchDuration = Int(sender.value)
        print("durationSliderChanged to \(advancedSearchDuration)")
        searchResultsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.none)
    }
    func weightSliderChanged(_ sender: UISlider){
        advancedSearchWeight = Int(sender.value)
        print("weightSliderChanged to \(advancedSearchWeight)")
        searchResultsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.none)
    }
    /*func  makeAdvancedSearchCell(indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView
        
    }*/
    func makeRecipeCell(indexPath: IndexPath) -> UITableViewCell{
        let screenHeight = self.view.frame.height
        let screenWidth = self.view.frame.width
        let cellHeight =  screenHeight/3
        
        let cell = UITableViewCell()
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: screenWidth*0.4, height: cellHeight*0.1)
        titleLabel.text = recies[(indexPath as NSIndexPath).row].recie?._name
        
        let descLabel = UILabel()
        descLabel.frame = CGRect(x: 0, y: cellHeight*0.2, width: screenWidth*0.6, height: cellHeight*0.1)
        descLabel.text = recies[(indexPath as NSIndexPath).row].recie?._description
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/4)
        let pcvframe = CGRect(x: 0, y: cellHeight*0.3, width: screenWidth, height: cellHeight*0.7)
        let picsCollectionView = UICollectionView(frame: pcvframe, collectionViewLayout: layout)
        picsCollectionView.tag = indexPath.row
        //picsCollectionView.delegate = self
        //picsCollectionView.dataSource = self
        picsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "pictureCell") //(registerClass: UICollectionViewCell(), forCellWithReuseIdentifier: "pictureCell")
        
        
        cell.addSubview(titleLabel)
        cell.addSubview(descLabel)
        cell.addSubview(picsCollectionView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //switch(tableView){
        //case ovenTableView:
        //    queryOvenData()
        //    break
        //default:
        //    scanRecipeData()
        //    break
        //}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = self.view.frame.height
        return screenHeight/3
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //populatePicturesAtIndex(i: indexPath.row)
    }
    // ---------------- --------------- table view code
    
    func showAlertWithTitle(title: String, message: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
