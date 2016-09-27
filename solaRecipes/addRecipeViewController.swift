//
//  addRecipeViewController.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 9/16/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class addRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    var titleTextView = UITextView()
    var descriptionTextView = UITextView()
    var instructionsTextView = UITextView()
    var pictures = [UIImage]()
    
    @IBOutlet weak var recipeDataTableView: UITableView!
    
    @IBAction func addPictureButtonClicked(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeDataTableView.delegate = self
        recipeDataTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //addPictureButton.setBackgroundImage(image, forState: UIControlState.Normal)
        pictures.append(image)
        self.dismissViewControllerAnimated(true, completion: nil)
        recipeDataTableView.reloadData()// (, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    //----------------------------- COLLECTIONVIEW CODE -------------------------------- starts

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let screenHeight = self.view.frame.height
        let cellHeight =  screenHeight/3
        let screenWidth = self.view.frame.width
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath)
        let pictureView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: cellHeight*0.9))
        if(indexPath.row == 0){
            pictureView.image = UIImage(named: "plus.jpg")
        }
        else{
            pictureView.image = pictures[indexPath.row - 1]
        }
        cell.addSubview(pictureView)
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //----------------------------- COLLECTIONVIEW CODE -------------------------------- ends

    
    //----------------------------- TABLEVIEW CODE -------------------------------- starts
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.row){
        case 0:
            //let cell = tableView.dequeueReusableCellWithIdentifier("titleCell") as! recipeTitleTableViewCell
            //cell.backgroundColor = UIColor.blueColor()
            return makeTitleInputCell("Title")
        case 1:
            //let cell = tableView.dequeueReusableCellWithIdentifier("picturesCollectionCell") as! recipePicturesCollectionTableViewCell
            return makePicturesCollectionCell()
        case 2:
            //let cell = tableView.dequeueReusableCellWithIdentifier("textInfoCell") as! recipeTextInforTableViewCell
            
            return makeTitleInputCell("Description")
        case 3:
            //let cell = tableView.dequeueReusableCellWithIdentifier("textInfoCell") as! recipeTextInforTableViewCell
            return makeTitleInputCell("Instructions")
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "submit"
            cell.backgroundColor = UIColor.blueColor()
            return cell
        }
    }
    func makePicturesCollectionCell() -> UITableViewCell{
        let cell = recipeDataTableView.dequeueReusableCellWithIdentifier("picturesCollectionCell") as! recipePicturesCollectionTableViewCell
        let screenHeight = self.view.frame.height
        let cellHeight =  screenHeight/3
        let screenWidth = self.view.frame.width
        
        cell.picturesCollectionView.delegate = self
        cell.picturesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(screenWidth/4, screenWidth/4)
        cell.picturesCollectionView.collectionViewLayout = layout
        
        return cell
    }
    func makeTitleInputCell(type: String) -> UITableViewCell{
        let screenHeight = self.view.frame.height
        var cellHeight =  screenHeight/8
        let screenWidth = self.view.frame.width
        let cell = UITableViewCell()
        let typeLabel = UILabel()
        let someTextView = UITextView()
        someTextView.text = "ahmed gamed fash5"
        someTextView.backgroundColor = UIColor.purpleColor()
        switch(type){
        case "Title":
            cellHeight =  screenHeight/8
            someTextView.frame = CGRect(x: screenWidth/3, y: cellHeight*0.1, width: screenWidth*0.66, height: cellHeight*0.8)
            self.titleTextView = someTextView
            cell.addSubview(titleTextView)
            break
        case "Description":
            cellHeight =  screenHeight/5
            someTextView.frame = CGRect(x: screenWidth/3, y: cellHeight*0.1, width: screenWidth*0.66, height: cellHeight*0.8)
            self.descriptionTextView = someTextView
            cell.addSubview(descriptionTextView)
            break
        case "Instructions":
            cellHeight =  screenHeight/3
            someTextView.frame = CGRect(x: screenWidth/3, y: cellHeight*0.1, width: screenWidth*0.66, height: cellHeight*0.8)
            self.instructionsTextView = someTextView
            cell.addSubview(instructionsTextView)
            break
        default:
            break
        }
        
        typeLabel.frame = CGRect(x: 0, y: cellHeight/2, width: 100, height: 20)
        typeLabel.text = "\(type): "
        cell.addSubview(typeLabel)
        
        cell.backgroundColor = UIColor.blueColor()
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let screenHeight = self.view.frame.height
        switch(indexPath.row){
        case 0:
            return screenHeight/8
        case 1:
            return screenHeight/3
        case 2:
            return screenHeight/5
        case 3:
            return screenHeight/3
        default:
            return screenHeight/8
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 4){
            print("submit recipe clicked")
            let newRecipe = recipe()
            newRecipe._name = titleTextView.text
            newRecipe._description = descriptionTextView.text
            newRecipe._temperature = "100"
            newRecipe._userId = AWSIdentityManager.defaultIdentityManager().identityId!
            print(titleTextView.text)
            
            //insertData(newRecipe)
            self.uploadRecipe(newRecipe).continueWithBlock({
                (task: AWSTask!) -> AWSTask! in
                
                if (task.error != nil) {
                    NSLog(task.error!.description)
                } else {
                    NSLog("DynamoDB save succeeded")
                }
                return nil
            })
        }
    }
    func uploadRecipe(recie: recipe) -> AWSTask! {
        let mapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let task = mapper.save(recie)
        return(AWSTask(forCompletionOfAllTasks: [task]))
    }
    func insertData(recie: recipe){
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        objectMapper.save(recie, completionHandler: {(error: NSError?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
        })
    }
}
