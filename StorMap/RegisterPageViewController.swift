//
//  RegisterPageViewController.swift
//  StorMap
//
//  Created by 林楷翊 on 08/03/2017.
//  Copyright © 2017 林楷翊. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
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
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func alertMsg(msg: String){
        let myAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        myAlert.addAction(ok)
        
        self.present(myAlert, animated: true,completion: nil)
        
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        let userName = userNameTextField!.text
        let userPassword = userPasswordTextField!.text
        let confirmPassword = confirmPasswordTextField!.text
        
        if((userName?.isEmpty)! || (userPassword?.isEmpty)! || (confirmPassword?.isEmpty)!){
            
            alertMsg(msg: "All Fields are required")
            return
        }
        
        if(userPassword != confirmPassword){
            alertMsg(msg: "Passwords do not match")
            return
            
        }
        
        UserDefaults.standard.set(userName, forKey:  "userName")
        
        UserDefaults.standard.set(userPassword, forKey: "userPassword")
        
        UserDefaults.standard.synchronize()
        
        
        let myAlert = UIAlertController(title: "Alert", message: "Welcome to StorMap, " + userName!, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "ok", style: .default) { action in self.dismiss(animated: true, completion: nil)
            }
        
        myAlert.addAction(ok)
        
        self.present(myAlert, animated: true,completion: nil)
    }

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
    }
    */

}
