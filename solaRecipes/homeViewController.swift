//
//  homeViewController.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 9/13/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSMobileHubHelper
import AWSS3

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var ovenTableView: UITableView!
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var recies = [recipe]()
    var ovens = [oven]()
    var recipeCreatorPPDownloadedAtIndex = [Bool]()
    
    private var manager: AWSUserFileManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        
        ovenTableView.delegate = self
        ovenTableView.dataSource = self
        
        queryRecipeData()
        ovenTableView.isHidden = true
        recipeTableView.isHidden = false
        
        let S3Bucket = "solarrecipes-userfiles-mobilehub-623139932"
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .usEast1, identityPoolId: "us-east-1:0f8aff81-0c9c-41f4-bd2a-e9083e706388")
        let configuration = AWSServiceConfiguration(region: .usEast1, credentialsProvider: credentialProvider)
        let userFileManagerConfiguration = AWSUserFileManagerConfiguration(bucketName: S3Bucket, serviceConfiguration: configuration)
        
        AWSUserFileManager.register(with: userFileManagerConfiguration, forKey: "randomManagerIJustCreated")
        
        manager = AWSUserFileManager.UserFileManager(forKey: "randomManagerIJustCreated")
        
        
        
        //let content = AWSContent()
        //downloadContent(content: content, pinOnCompletion: true)
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
        dynamoDBObjectMapper.scan(DBRecipe.self, expression: queryExpression).continue({ (task:AWSTask!) -> AnyObject! in
            
            print("task result is \(task.result)")
            if task.result != nil {
                
                let paginatedOutput = task.result as? AWSDynamoDBPaginatedOutput!
                
                var i = 0
                for item in paginatedOutput?.items as! [DBRecipe] {
                    //NSLog(item.M!.stringValue)
                    let newRecie = recipe(recip: item)
                    self.recies.append(newRecie)
                    self.recipeCreatorPPDownloadedAtIndex.append(false)
                    DispatchQueue.main.async(execute: {
                        self.recipeTableView.reloadData()
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
    func queryOvenData(){
        self.ovens.removeAll()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.limit = 100;
        dynamoDBObjectMapper.scan(oven.self, expression: queryExpression).continue({ (task:AWSTask!) -> AnyObject! in
            
            print("task result is \(task.result)")
            if task.result != nil {
                
                let paginatedOutput = task.result as? AWSDynamoDBPaginatedOutput!
                
                var i = 0
                for item in paginatedOutput?.items as! [oven] {
                    //NSLog(item.M!.stringValue)
                    self.ovens.append(item)
                    DispatchQueue.main.async(execute: {
                        self.recipeTableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ---------------- --------------- table view code
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            /*
             let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
             cell.textLabel?.text = recies[(indexPath as NSIndexPath).row]._name
             cell.detailTextLabel?.text = recies[(indexPath as NSIndexPath).row]._description
             return cell
             */
            return makeRecipeCell(indexPath: indexPath)
        }
    }
    func makeRecipeCell(indexPath: IndexPath) -> UITableViewCell{
        let screenHeight = self.view.frame.height
        let screenWidth = self.view.frame.width
        let cellHeight =  screenHeight/2
        
        let cell = UITableViewCell()
        
        let userPicButton = UIButton()
        userPicButton.frame = CGRect(x: 0, y: 0, width: screenWidth*0.2, height: screenWidth*0.2)
        userPicButton.setBackgroundImage(recies[(indexPath as NSIndexPath).row].creatorPP , for: UIControlState.normal)
        
        let userNameLabel = UILabel()
        userNameLabel.frame = CGRect(x: screenWidth*0.3, y: cellHeight*0.05, width: screenWidth*0.7, height: cellHeight*0.1)
        userNameLabel.text = recies[(indexPath as NSIndexPath).row].recie?._creatorName
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: screenWidth*0.2, width: screenWidth*0.4, height: cellHeight*0.1)
        titleLabel.text = recies[(indexPath as NSIndexPath).row].recie?._name
        
        let descLabel = UILabel()
        descLabel.frame = CGRect(x: screenWidth*0.4, y: screenWidth*0.2, width: screenWidth*0.6, height: cellHeight*0.1)
        descLabel.text = recies[(indexPath as NSIndexPath).row].recie?._description
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/4)
        let pcvframe = CGRect(x: 0, y: cellHeight*0.3, width: screenWidth, height: cellHeight*0.5)
        let picsCollectionView = UICollectionView(frame: pcvframe, collectionViewLayout: layout)
        picsCollectionView.tag = indexPath.row
        picsCollectionView.delegate = self
        picsCollectionView.dataSource = self
        picsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "pictureCell") //(registerClass: UICollectionViewCell(), forCellWithReuseIdentifier: "pictureCell")
        
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: 0, y: cellHeight*0.85, width: screenWidth*0.5, height: cellHeight*0.1)
        
        tempLabel.text = "temp: \((recies[(indexPath as NSIndexPath).row].recie?._temperature)!)F"
        
        let durationLabel = UILabel()
        durationLabel.frame = CGRect(x: screenWidth*0.5, y: cellHeight*0.85, width: screenWidth*0.5, height: cellHeight*0.1)
        durationLabel.text = "ETA: \((recies[(indexPath as NSIndexPath).row].recie?._duration)!)mins"
        
        
        cell.addSubview(userPicButton)
        cell.addSubview(userNameLabel)
        cell.addSubview(titleLabel)
        cell.addSubview(descLabel)
        cell.addSubview(picsCollectionView)
        cell.addSubview(tempLabel)
        cell.addSubview(durationLabel)
        
        return cell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = self.view.frame.height
        return screenHeight/2
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        populatePicturesAtIndex(i: indexPath.row)
    }
    // ---------------- --------------- table view code
    
    //----------------------------- COLLECTIONVIEW CODE -------------------------------- starts
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(collectionView){
        case ovenTableView:
            return 0
            break
        default:
            return recies[collectionView.tag].picures.count
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colHeight = collectionView.frame.height
        let cellHeight =  (colHeight)*0.8
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath)
        
        let pictureView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight))
        let image = recies[collectionView.tag].picures[indexPath.row]
        pictureView.image = image
        pictureView.contentMode = UIViewContentMode.scaleAspectFill
        cell.addSubview(pictureView)
        
        //cell.backgroundColor = UIColor(patternImage: recies[collectionView.tag].picures[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = self.view.frame.height
        let cellHeight =  (screenHeight/3)*0.7
        return CGSize(width: cellHeight, height: cellHeight)
    }
    
    //----------------------------- COLLECTIONVIEW CODE -------------------------------- ends
    func populatePicturesAtIndex(i: Int){
        
        if(recies[i].picures.count == 0){
            recies[i].picures.append(UIImage(named: "plus.jpg")!)
            //S3DownloadPicture(recipeIndex: i)
            loadContentsAtDirectory(prefix: "public/\((recies[i].recie?._name!)!)/", i: i)
            if(!recipeCreatorPPDownloadedAtIndex[i]){
                
                
                let FBID = recies[i].recie?._creatorFBID!
                getFBProfilePicForIndex(userFBID: FBID! as String, i: i)
                recipeCreatorPPDownloadedAtIndex[i] = true
            }
        }
        
    }
    /*
     func loadMoreContents(){
     let S3Bucket = "solarrecipes-userfiles-mobilehub-623139932"
     let credentialProvider = AWSCognitoCredentialsProvider(regionType: .usEast1, identityPoolId: "us-east-1:0f8aff81-0c9c-41f4-bd2a-e9083e706388")
     let configuration = AWSServiceConfiguration(region: .usEast1, credentialsProvider: credentialProvider)
     let userFileManagerConfiguration = AWSUserFileManagerConfiguration(bucketName: S3Bucket, serviceConfiguration: configuration)
     
     AWSUserFileManager.register(with: userFileManagerConfiguration, forKey: "randomManagerIJustCreated")
     
     let manager = AWSUserFileManager.UserFileManager(forKey: "randomManagerIJustCreated")
     var contentsHere = [AWSContent]()
     var didLoadAllContents = false
     var markerHere: String?
     manager.listAvailableContents(withPrefix: "public/", marker: nil, completionHandler: {[weak self](contents: [AWSContent]?, nextMarker: String?, error: NSError?) -> Void in
     guard let strongSelf = self else { return }
     if let error = error {
     print("Failed to load the list of contents. \(error)")
     }
     if let contents = contents , contents.count > 0 {
     contentsHere = contents
     if let nextMarker = nextMarker , !nextMarker.isEmpty {
     didLoadAllContents = false
     } else {
     didLoadAllContents = true
     }
     markerHere = nextMarker
     }
     print(contentsHere)
     } as! ([AWSContent]?, String?, Error?) -> Void
     }*/
    func S3DownloadPicture(recipeIndex: Int){
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        var downloadFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(recies[recipeIndex].recie?._name)/picture1")
        
        let S3Bucket = "solarrecipes-userfiles-mobilehub-623139932"
        
        downloadRequest!.bucket = S3Bucket
        downloadRequest!.key = "/example-image.png"//\(recies[recipeIndex]._name)/picture1"
        downloadRequest!.downloadingFileURL = downloadFileURL
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.usEast1,identityPoolId:"us-east-1:0f8aff81-0c9c-41f4-bd2a-e9083e706388")
        
        let configuration = AWSServiceConfiguration(region:.usEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        let transferManager = AWSS3TransferManager.default()
        
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        transferManager?.download(downloadRequest).continue({ (task) -> AnyObject! in
            if let error = task.error {
                print("download failed or paused: [\(error)] \n")
            } else if let exception = task.exception {
                print("download failed: [\(exception)] \n")
            } else {
                //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print("i'm in download()  ")
                downloadFileURL = downloadRequest?.downloadingFileURL
                //})
            }
            if((task.result) != nil){
                print("downloaded??")
                print(downloadFileURL!.path)
                self.recies[recipeIndex].picures.append(UIImage(contentsOfFile: downloadFileURL!.path)!)
            }
            else{
                
            }
            return nil
        })
        
    }
    
    private func downloadContent(content: AWSContent, pinOnCompletion: Bool, i: Int) {
        content.download(
            with: .ifNewerExists,
            pinOnCompletion: pinOnCompletion,
            progressBlock: {[weak self](content: AWSContent?, progress: Progress?) -> Void in
                guard self != nil else { return }
                /* Show progress in UI. */
            },
            completionHandler: {[weak self](content: AWSContent?, data: Data?, error: Error?) -> Void in
                guard self != nil else { return }
                if let error = error {
                    print("Failed to download a content from a server. \(error)")
                    return
                }
                print("Object download complete.")
                print("downloaded??")
                self?.recies[i].picures.append(UIImage(data: data!)!)
                DispatchQueue.main.async(execute: {
                    self?.recipeTableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: UITableViewRowAnimation.automatic)
                })
                print(content)
                
            })
    }
    private func loadContentsAtDirectory(prefix: String, i: Int) {
        print("prefix recieved was \(prefix)")
        var contentsHere: [AWSContent]?
        var markerHere: String?
        var didLoadAllContents: Bool!
        manager.listAvailableContents(withPrefix: prefix, marker: markerHere, completionHandler: {[weak self](contents: [AWSContent]?, nextMarker: String?, error: Error?) -> Void in
            guard let strongSelf = self else { return }
            if let error = error {
                
                print("Failed to load the list of contents. \(error)")
            }
            if let contents = contents , contents.count > 0 {
                contentsHere = contents
                if let nextMarker = nextMarker , !nextMarker.isEmpty {
                    didLoadAllContents = false
                } else {
                    didLoadAllContents = true
                }
                markerHere = nextMarker
            }
            
            print("contents is \(contentsHere)")
            if (contentsHere != nil){
                for temp in contentsHere!{
                    print(temp.key)
                    self?.downloadContent(content: temp, pinOnCompletion: false, i:i)
                }
            }
            })
    }
    func getFBProfilePicForIndex(userFBID: String, i: Int){
        let picURL = URL(string: "https://graph.facebook.com/\(userFBID)/picture?type=large")
        print(picURL)
        
        print("Download Started")
        getDataFromUrl(url: picURL!) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? picURL?.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let image = UIImage(data: data)
                self.recies[i].creatorPP = image!
            }
        }
        
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}
