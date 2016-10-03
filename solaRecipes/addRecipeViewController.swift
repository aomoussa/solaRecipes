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

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var titleTextView = UITextView()
    var descriptionTextView = UITextView()
    var instructionsTextView = UITextView()
    var pictures = [UIImage]()
    
    @IBOutlet weak var recipeDataTableView: UITableView!
    
    @IBAction func addPictureButtonClicked(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func segmedChanged(_ sender: UISegmentedControl) {
        switch(getSegmentedControlState(sc: sender)){
        case "ovens":
            break
        default:
            break
        }
    }
    func getSegmentedControlState(sc: UISegmentedControl) -> String{
        switch(sc.selectedSegmentIndex){
        case 1:
            return "ovens"
        default:
            return "recipes"
        }
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
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //addPictureButton.setBackgroundImage(image, forState: UIControlState.Normal)
        pictures.append(image)
        self.dismiss(animated: true, completion: nil)
        recipeDataTableView.reloadData()// (, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    //----------------------------- COLLECTIONVIEW CODE -------------------------------- starts

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let screenHeight = self.view.frame.height
        let cellHeight =  screenHeight/3
        let screenWidth = self.view.frame.width
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath)
        let pictureView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: cellHeight*0.9))
        if((indexPath as NSIndexPath).row == 0){
            pictureView.image = UIImage(named: "plus.jpg")
        }
        else{
            pictureView.image = pictures[(indexPath as NSIndexPath).row - 1]
        }
        cell.addSubview(pictureView)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).row == 0){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //----------------------------- COLLECTIONVIEW CODE -------------------------------- ends

    
    //----------------------------- TABLEVIEW CODE -------------------------------- starts
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch((indexPath as NSIndexPath).row){
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
            cell.backgroundColor = UIColor.blue
            return cell
        }
    }
    func makePicturesCollectionCell() -> UITableViewCell{
        let cell = recipeDataTableView.dequeueReusableCell(withIdentifier: "picturesCollectionCell") as! recipePicturesCollectionTableViewCell
        let screenHeight = self.view.frame.height
        let cellHeight =  screenHeight/3
        let screenWidth = self.view.frame.width
        
        cell.picturesCollectionView.delegate = self
        cell.picturesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/4)
        cell.picturesCollectionView.collectionViewLayout = layout
        
        return cell
    }
    func makeTitleInputCell(_ type: String) -> UITableViewCell{
        let screenHeight = self.view.frame.height
        var cellHeight =  screenHeight/8
        let screenWidth = self.view.frame.width
        let cell = UITableViewCell()
        let typeLabel = UILabel()
        let someTextView = UITextView()
        someTextView.text = "ahmed gamed fash5"
        someTextView.backgroundColor = UIColor.purple
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
        
        cell.backgroundColor = UIColor.blue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = self.view.frame.height
        switch((indexPath as NSIndexPath).row){
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).row == 4){
            print("submit recipe clicked")
            
            switch(getSegmentedControlState(sc: segmentedControl)){
            case "ovens":
                makeAndSubmitOven()
                break
            default:
                makeAndSubmitRecipe()
                break
            }
            //insertData(newRecipe)
            uploadPictures(pictures)
            
        }
    }
    func uploadPictures(_ pictures: [UIImage]){
        if(pictures.count > 0){
            glblFileTransferHandler.upload("randomNameForNow.jpg", picture: pictures[0])
        }
    }
    func makeAndSubmitOven(){
        let newOven = oven()
        newOven?._id = "3"
        newOven?._name = titleTextView.text
        newOven?._description = descriptionTextView.text
        newOven?._instructions = instructionsTextView.text
        newOven?._userID = "1"
        
        
        self.uploadOven(newOven!).continue({
            (task: AWSTask!) -> AWSTask<AnyObject>! in
            
            if (task.error != nil) {
                print(task.error)
            } else {
                NSLog("DynamoDB save succeeded")
            }
            return nil
        })
        
    }
    func makeAndSubmitRecipe(){
        let newRecipe = recipe()
        newRecipe?._id = "1"
        newRecipe?._name = titleTextView.text
        newRecipe?._instructions = instructionsTextView.text
        newRecipe?._description = descriptionTextView.text
        newRecipe?._temperature = "100"
        newRecipe?._duration = "60"
        newRecipe?._userID = AWSIdentityManager.default().identityId!
        
        print(titleTextView.text)
        self.uploadRecipe(newRecipe!).continue({
            (task: AWSTask!) -> AWSTask<AnyObject>! in
            
            if (task.error != nil) {
                print(task.error)
            } else {
                NSLog("DynamoDB save succeeded")
            }
            return nil
        })
    }
    func uploadOven(_ ovn: oven) -> AWSTask<AnyObject>! {
        let mapper = AWSDynamoDBObjectMapper.default()
        let task = mapper.save(ovn)
        return(AWSTask(forCompletionOfAllTasks: [task]))
    }
    func uploadRecipe(_ recie: recipe) -> AWSTask<AnyObject>! {
        let mapper = AWSDynamoDBObjectMapper.default()
        let task = mapper.save(recie)
        return(AWSTask(forCompletionOfAllTasks: [task]))
    }
    func insertData(_ recie: recipe){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.save(recie, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
        })
    }
}
