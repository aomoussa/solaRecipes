//
//  userSettingsViewController.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 10/27/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import AWSMobileHubHelper

class userSettingsViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    @IBOutlet weak var profilePictureButton: UIButton!
    
    var FBID = ""
    var FBName = ""

    override func viewDidLoad() {
        
        
        //let userNameLabel = UILabel()
        if AccessToken.current != nil {
            getFBProfile(accessToken: AccessToken.current!)
        }
        
        // Add a custom login button to your app
        let FBLogoutButton = UIButton()
        FBLogoutButton.backgroundColor = UIColor.blue
        FBLogoutButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40);
        FBLogoutButton.center = view.center;
        FBLogoutButton.setTitle("Logout from Facebook", for: .normal)
        
        // Handle clicks on the button
        FBLogoutButton.addTarget(self, action: #selector(self.logoutButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(FBLogoutButton)
    }
    
    // Once the button is clicked, show the login dialog
    func logoutButtonClicked() {
        if let accessToken = AccessToken.current {
            let loginManager = LoginManager()
            loginManager.logOut()
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        else{
            print("you were never logged in? this shouldn't happen i think")
        }
    }

    func getFBProfile(accessToken: AccessToken){
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"name"], accessToken: accessToken, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        req.start { (response, result) in
            switch result {
            case .success(let value):
                print(value.dictionaryValue)
                print(value.stringValue)
                print(value.arrayValue)
                
                self.FBID = value.dictionaryValue!["id"] as! String //["id"] //(forKey: "id")
                self.FBName = value.dictionaryValue!["name"] as! String
                print(self.FBID)
                print(self.FBName)
                self.userNameLabel.text = self.FBName
                self.getFBProfilePic(userFBID: self.FBID)
                //print(value.dictionaryValue)
            case .failed(let error):
                print(error)
            }
        }
    }
    func getFBProfilePic(userFBID: String){
        /*
        let pictureRequest = GraphRequest(graphPath: "me/picture?type=normal&redirect=false")
        pictureRequest.start{
            (connection, result) in
            
            if result != nil {
                
                let imageData = result //.objectForKey("data") as! NSDictionary
                let dataURL = data.objectForKey("url") as! String
                let pictureURL = NSURL(string: dataURL)
                imageData = NSData(contentsOfURL: pictureURL!)
                let image = UIImage(data: imageData!)
                
            }
        }*/
    }
        /*
        let picURL = URL(fileURLWithPath: "https://graph.facebook.com/\(userFBID)/picture?type=large")
        //let picURLRequest = URLRequest(url: picURL)
        //let session = URLSession.shared
        let task = URLSession.shared.dataTask(with: picURL) { (Data, URLResponse, Error) in
            if(Error == nil){
                let image = UIImage(data: Data!)
                self.profilePictureButton.setImage(image, for: UIControlState.normal)
                self.activityInd.alpha = 0
           }
            else{
                print(Error)
            }
        }
        
        
        
        //NSURLConnection.sendAsynchronousRequest(picURLRequest, queue: OperationQueue.mainQueue) { (response: URLResponse!, data: Data!, error: Error!) -> Void in
            
            // Display the image
            //let image = UIImage(data: data)
            //self.profilePic.image = image
        //}
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
