//
//  loginViewController.swift
//  solaRecipes
//
//  Created by Ahmed Moussa on 10/25/16.
//  Copyright © 2016 Ahmed Moussa. All rights reserved.
//

import UIKit
//import FBSDKLoginKit
import FacebookLogin
import FacebookCore

class loginViewController: UIViewController {
    
    override func viewDidLoad() {
        
        // Add a custom login button to your app
        let FBLoginButton = UIButton()
        FBLoginButton.backgroundColor = UIColor.blue
        FBLoginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40);
        FBLoginButton.center = view.center;
        FBLoginButton.setTitle("Login thru Facebook", for: .normal)
        
        // Handle clicks on the button
        FBLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(FBLoginButton)
    }
    
    // Once the button is clicked, show the login dialog
    func loginButtonClicked() {
        if let accessToken = AccessToken.current {
            self.performSegue(withIdentifier: "toTabViews", sender: self)
        }
        else{
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
                self.performSegue(withIdentifier: "toTabViews", sender: self)
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                self.performSegue(withIdentifier: "toTabViews", sender: self)
            }
        }
        }
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
