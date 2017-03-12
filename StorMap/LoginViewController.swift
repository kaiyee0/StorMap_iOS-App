//
//  LoginViewController.swift
//  StorMap
//
//  Created by 林楷翊 on 10/03/2017.
//  Copyright © 2017 林楷翊. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenSize = UIScreen.main.bounds.size
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        UIImage(named: "bg1.png")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        var headLabel: UILabel!
        
        //add the hading label of the app
        headLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        
        headLabel.text = "StorMap"
        headLabel.font = UIFont.boldSystemFont(ofSize: 60)
        headLabel.textColor = UIColor.darkGray
        headLabel.textAlignment = .center
        headLabel.numberOfLines = 1
        headLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        headLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.15)
        self.view.addSubview(headLabel)
        
        
        var subLabel: UILabel!
        //add the sub label of the app
        subLabel = UILabel(frame: CGRect(x: 0, y: 0 , width: 500, height: 80))
        subLabel.text = "Live it, \n\t\t\t\t\t leave it ..."
        subLabel.font = UIFont(name: "SnellRoundhand-Bold", size: 30)
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 2
        subLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        subLabel.center = CGPoint(x: fullScreenSize.width * 0.65, y: fullScreenSize.height * 0.27)
        self.view.addSubview(subLabel)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func loginBtn(_ sender: Any) {
        let userName = userNameTextField!.text
        let userPassword = userPasswordTextField!.text
        
        let userNameStored = UserDefaults.standard.string(forKey:"userName")
        
        let userPasswordStored = UserDefaults.standard.string(forKey:"userPassword")
        
        if(userNameStored == userName){
            if(userPasswordStored == userPassword){
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                let welcomeMsg = UIAlertController(title: "Alert", message: "welcome, " + userName!, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "ok", style: .default) { action in self.dismiss(animated: true, completion: nil)
                }
                
                welcomeMsg.addAction(ok)
                
                self.present(welcomeMsg, animated: true,completion: nil)
                self.performSegue(withIdentifier: "goLoginPage_user", sender: self)
            }
        }
        else{
            
        }
        
        
        
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
