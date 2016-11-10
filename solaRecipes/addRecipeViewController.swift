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
import FacebookCore

class addRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var titleTextView = UITextView()
    var descriptionTextView = UITextView()
    var instructionsTextView = UITextView()
    var titleString = "enter title here"
    var descString = "enter description here"
    var instString = "enter instructions here"
    var duration = 10
    var pictures = [UIImage]()
    var uploadProgresses = [Float]()
    
    
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
        print("sc.selectedSegmentIndex: \(sc.selectedSegmentIndex)")
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
        uploadProgresses.append(0.0)
        self.dismiss(animated: true, completion: nil)
        let ind = IndexPath(row: 1, section: 0)
        recipeDataTableView.reloadRows(at: [ind], with: UITableViewRowAnimation.automatic)
        //recipeDataTableView.reloadData()// (, withRowAnimation: UITableViewRowAnimation.Automatic)
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
        let pictureView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellHeight*0.9, height: cellHeight*0.9))
        if((indexPath as NSIndexPath).row == 0){
            pictureView.image = UIImage(named: "plus.jpg")
        }
        else{
            pictureView.image = pictures[(indexPath as NSIndexPath).row - 1]
        }
        pictureView.contentMode = UIViewContentMode.scaleAspectFill
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = self.view.frame.height
        let cellHeight =  (screenHeight/3)*0.9
        return CGSize(width: cellHeight, height: cellHeight)
    }
    
    //----------------------------- COLLECTIONVIEW CODE -------------------------------- ends
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        switch(textView){
        case titleTextView:
            titleString = titleTextView.text
            break
        case descriptionTextView:
            descString = descriptionTextView.text
            break
        case instructionsTextView:
            instString = instructionsTextView.text
            break
        default:
            titleString = titleTextView.text
            break
        }
        view.endEditing(true)
    }
    func durationChanged(_ sender: UIDatePicker){
        self.duration = Int(sender.countDownDuration)/60
        print(self.duration)
        
    }
    
    //----------------------------- TABLEVIEW CODE -------------------------------- starts
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
            return makeDurationCell()
        case 4:
            //let cell = tableView.dequeueReusableCellWithIdentifier("textInfoCell") as! recipeTextInforTableViewCell
            return makeTitleInputCell("Instructions")
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "submit"
            cell.backgroundColor = UIColor.blue
            return cell
        }
    }
    func makeDurationCell() -> UITableViewCell{
        let screenHeight = self.view.frame.height
        let cellHeight =  screenHeight/3
        let screenWidth = self.view.frame.width
        
        let cell = UITableViewCell()
        
        let durationTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: cellHeight*0.2))
        durationTitleLabel.text = "Duration: "
        
        let durationSelector = UIDatePicker(frame: CGRect(x: 0, y: cellHeight*0.2, width: screenWidth, height: cellHeight*0.8))
        durationSelector.datePickerMode = .countDownTimer
        
        durationSelector.addTarget(self, action: #selector(addRecipeViewController.durationChanged(_:)), for: UIControlEvents.valueChanged)
        
        
        cell.addSubview(durationSelector)
        cell.addSubview(durationTitleLabel)
        
        cell.backgroundColor = UIColor.orange
        return cell
    }
    func makePicturesCollectionCell() -> UITableViewCell{
        let cell = recipeDataTableView.dequeueReusableCell(withIdentifier: "picturesCollectionCell") as! recipePicturesCollectionTableViewCell
        let screenHeight = self.view.frame.height
        let cellHeight =  screenHeight/3
        let screenWidth = self.view.frame.width
        
        cell.picturesCollectionView.delegate = self
        cell.picturesCollectionView.dataSource = self
        cell.picturesCollectionView.backgroundColor = UIColor.orange
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
        
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        instructionsTextView.delegate = self
        
        someTextView.backgroundColor = UIColor.white
        switch(type){
        case "Title":
            cellHeight =  screenHeight/8
            someTextView.frame = CGRect(x: screenWidth/3, y: cellHeight*0.1, width: screenWidth*0.66, height: cellHeight*0.8)
            self.titleTextView = someTextView
            self.titleTextView.text = titleString
            self.titleTextView.selectedTextRange = self.titleTextView.textRange(from: self.titleTextView.beginningOfDocument, to: self.titleTextView.endOfDocument)
            cell.addSubview(titleTextView)
            break
        case "Description":
            cellHeight =  screenHeight/5
            someTextView.frame = CGRect(x: screenWidth/3, y: cellHeight*0.1, width: screenWidth*0.66, height: cellHeight*0.8)
            self.descriptionTextView = someTextView
            self.descriptionTextView.text = descString
            cell.addSubview(descriptionTextView)
            break
        case "Instructions":
            cellHeight =  screenHeight/3
            someTextView.frame = CGRect(x: screenWidth/3, y: cellHeight*0.1, width: screenWidth*0.66, height: cellHeight*0.8)
            self.instructionsTextView = someTextView
            self.instructionsTextView.text = instString
            cell.addSubview(instructionsTextView)
            break
        default:
            break
        }
        
        typeLabel.frame = CGRect(x: 0, y: cellHeight/2, width: 100, height: 20)
        typeLabel.text = "\(type): "
        cell.addSubview(typeLabel)
        
        cell.backgroundColor = UIColor.orange
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
        case 4:
            return screenHeight/3
        default:
            return screenHeight/8
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        if((indexPath as NSIndexPath).row == 5){
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
            
        }
    }
    func uploadPictures(_ pictures: [UIImage], folderName: String){
        var i = 1
        for pic in pictures{
            let picName = "\(folderName)/ picture\(i)"
            uploadPicture(picName, picture: pic, i:i)
            i = i + 1
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
        
        let id = "2"
        let name = titleTextView.text
        let instructions = instructionsTextView.text
        let description = descriptionTextView.text
        let temperature = 100 as NSNumber
        let duration = self.duration as NSNumber
        let numberOfPictures = pictures.count
        var newRecipe = recipe(id: id, name: name!, insts: instructions!, desc: description!, temp: temperature, dur: duration, creatorFBID: "1", creatorName: "ana gamed fash5", numOfPics: numberOfPictures)
        if(AccessToken.current != nil){
            getFBProfileAndUploadRecipe(recipe: newRecipe, accessToken: AccessToken.current!)
        }
    }
    func uploadOven(_ ovn: oven) -> AWSTask<AnyObject>! {
        let mapper = AWSDynamoDBObjectMapper.default()
        let task = mapper.save(ovn)
        return(AWSTask(forCompletionOfAllTasks: [task]))
    }
    func uploadRecipe(_ recie: DBRecipe) -> AWSTask<AnyObject>! {
        let mapper = AWSDynamoDBObjectMapper.default()
        let task = mapper.save(recie)
        return(AWSTask(forCompletionOfAllTasks: [task]))
    }
    func insertData(_ recie: DBRecipe){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.save(recie, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
        })
    }
    //----------- --------------- -------------- ---------- UPLOAD FILES ------------- ----------- ------------- //begins
    func uploadWithData(_ data: Data, forKey key: String, i: Int) {
        
        let S3Bucket = "solarrecipes-userfiles-mobilehub-623139932"
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .usEast1, identityPoolId: "us-east-1:0f8aff81-0c9c-41f4-bd2a-e9083e706388")
        let configuration = AWSServiceConfiguration(region: .usEast1, credentialsProvider: credentialProvider)
        let userFileManagerConfiguration = AWSUserFileManagerConfiguration(bucketName: S3Bucket, serviceConfiguration: configuration)
        
        AWSUserFileManager.register(with: userFileManagerConfiguration, forKey: "randomManagerIJustCreated")
        
        let manager = AWSUserFileManager.UserFileManager(forKey: "randomManagerIJustCreated")
        let localContent = manager.localContent(with: data, key: key)
        print("about to upload picture rn ")
        localContent.uploadWithPin(
            onCompletion: false,
            progressBlock: {[weak self](content: AWSLocalContent?, progress: Progress?) -> Void in
                guard let strongSelf = self else { return }
                /* Show progress in UI. */
                DispatchQueue.main.async(execute: { () -> Void in
                    print("not sure when this happens")
                    print(progress?.fractionCompleted)
                    //self?.uploadProgresses[i] = Float((progress?.fractionCompleted)!)
                })
            },
            completionHandler: {[weak self](content: AWSContent?, error: Error?) -> Void in
                guard let strongSelf = self else { return }
                if let error = error {
                    print("Failed to upload an object. \(error)")
                } else {
                    print("Object upload complete. \(error)")
                    //self?.segueIfAllUploadsCompleted()
                }
            })
    }
    func uploadPicture(_ picName: String, picture: UIImage, i: Int) {
        let key = "public/\(picName)"
        let imageData: Data = UIImageJPEGRepresentation(picture, 0.1)!//UIImagePNGRepresentation(picture)!
        
        
        uploadWithData(imageData, forKey: key, i:i)
        //S3Upload(picName, picture: picture)
    }
    func segueIfAllUploadsCompleted(){
        for temp in uploadProgresses{
            if(temp != 1.0){
                return
            }
        }
        self.tabBarController?.selectedIndex = 0
    }
    //----------- --------------- -------------- ---------- UPLOAD FILES ------------- ----------- ------------- //ends
    //----------- --------------- -------------- ---------- FACEBOOK GET ------------- ----------- ------------- //starts
    func getFBProfileAndUploadRecipe(recipe: recipe, accessToken: AccessToken) -> Bool{
        var whatToReturn = false
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"name"], accessToken: accessToken, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        req.start { (response, result) in
            switch result {
            case .success(let value):
                print(value.dictionaryValue)
                
                let creatorFBID = value.dictionaryValue!["id"] as! String //["id"] //(forKey: "id")
                let creatorName = value.dictionaryValue!["name"] as! String
                print(creatorFBID)
                print(creatorName)
                recipe.recie?._creatorFBID = creatorFBID
                recipe.recie?._creatorName = creatorName
                
                        self.uploadRecipe(recipe.recie!).continue({
                            (task: AWSTask!) -> AWSTask<AnyObject>! in
                            
                            if (task.error != nil) {
                                print(task.error)
                            } else {
                                NSLog("DynamoDB save succeeded")
                                
                                self.uploadPictures(self.pictures, folderName: (recipe.recie?._name)!)
                            }
                            return nil
                        })

            //print(value.dictionaryValue)
            case .failed(let error):
                print(error)
                whatToReturn = false
            }
        }
        return whatToReturn
    }
    //----------- --------------- -------------- ---------- FACEBOOK GET ------------- ----------- ------------- //ends
}
