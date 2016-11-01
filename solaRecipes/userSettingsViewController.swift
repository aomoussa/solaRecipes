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
        let ahmedsPicURL = URL(string: "https://graph.facebook.com/10155692326063868/picture?type=large")
        let picURL = URL(string: "https://graph.facebook.com/\(userFBID)/picture?type=large")
        print(picURL)
       
        print("Download Started")
        getDataFromUrl(url: picURL!) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? picURL?.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let image = UIImage(data: data)
                self.profilePictureButton.contentMode = .scaleAspectFill
                self.profilePictureButton.setImage(image, for: UIControlState.normal)
                self.activityInd.alpha = 0
                let imageView = UIImageView(image: image)
                imageView.frame = self.profilePictureButton.frame
                imageView.contentMode = .scaleAspectFit
                self.view.addSubview(imageView)
            }
        }
        
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
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
