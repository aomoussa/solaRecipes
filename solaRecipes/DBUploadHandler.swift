//
//  DBUploadHandler.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 3/6/17.
//  Copyright © 2017 Ahmed Moussa. All rights reserved.
//

import Foundation
import AWSDynamoDB
import AWSMobileHubHelper
import FacebookCore


class DBUploadHandler{
    var tvc = UIViewController()
    var uploadStatusView = UILabel()
    
    func makeLoadingView(){
        //iterative solution to topViewController from stackoverflow by rickerbh
        //http://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
            tvc = topController
        }
        
        let swidth = tvc.view.frame.width
        let sheight = tvc.view.frame.height
        
        uploadStatusView = UILabel(frame: CGRect(x: 0, y: 0, width: swidth, height: sheight*0.2))
        uploadStatusView.text = "UPLOADING..."
        uploadStatusView.backgroundColor = UIColor.gray
        tvc.view.addSubview(uploadStatusView)
    }
    func removeLoadingView(){
        uploadStatusView.removeFromSuperview()
    }
    init(){}
    func getFBProfileAndUploadRecipeAndPics(recipe: recipe, pictures: [UIImage], accessToken: AccessToken){
        
        makeLoadingView()
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"name"], accessToken: accessToken, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        req.start { (response, result) in
            switch result {
            case .success(let value):
                //print(value.dictionaryValue)
                
                let creatorFBID = value.dictionaryValue!["id"] as! String //["id"] //(forKey: "id")
                let creatorName = value.dictionaryValue!["name"] as! String
                //print(creatorFBID)
                //print(creatorName)
                recipe.recie?._creatorFBID = creatorFBID
                recipe.recie?._creatorName = creatorName
                
                self.uploadRecipe(recipe.recie!).continue({
                    (task: AWSTask!) -> AWSTask<AnyObject>! in
                    
                    if (task.error != nil) {
                        print(task.error!)
                    } else {
                        NSLog("DynamoDB save succeeded")
                        
                        //do this when done
                        self.uploadPictures(pictures, folderName: (recipe.recie?._name)!)
                    }
                    return nil
                })            //print(value.dictionaryValue)
            case .failed(let error):
                print(error)
            }
        }
    }
    
    func uploadRecipe(_ recie: DBRecipe) -> AWSTask<AnyObject>! {
        let mapper = AWSDynamoDBObjectMapper.default()
        let task = mapper.save(recie)
        return(AWSTask(forCompletionOfAllTasks: [task]))
    }
    func uploadPicture(_ picName: String, picture: UIImage, i: Int) {
        let key = "public/\(picName)"
        let imageData: Data = UIImageJPEGRepresentation(picture, 0.1)!
        
        uploadWithData(imageData, forKey: key, i:i)
    }
    func uploadPictures(_ pictures: [UIImage], folderName: String){
        var i = 1
        for pic in pictures{
            let picName = "\(folderName)/ picture\(i)"
            uploadPicture(picName, picture: pic, i:i)
            
            if(i==pictures.count){
                removeLoadingView()
                showAlertWithTitle(title: "Upload Complete!", message: "Your recipe/oven has been uploaded successfully")
            }
            i = i + 1
        }
    }
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
                guard self != nil else { return }
                /* Show progress in UI. */
                DispatchQueue.main.async(execute: { () -> Void in
                    print("not sure when this happens")
                    print(progress?.fractionCompleted)
                    //self?.uploadProgresses[i] = Float((progress?.fractionCompleted)!)
                })
            },
            completionHandler: {[weak self](content: AWSContent?, error: Error?) -> Void in
                guard self != nil else { return }
                if let error = error {
                    print("Failed to upload an object. \(error)")
                } else {
                    print("Object upload complete. \(error)")
                    
                }
        })
    }
    func showAlertWithTitle(title: String, message: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        tvc.present(alertController, animated: true, completion: nil)
    }
}
let glblUploadHandler = DBUploadHandler()
