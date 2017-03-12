//
//  FirstViewController.swift
//  StorMap
//
//  Created by 林楷翊 on 11/03/2017.
//  Copyright © 2017 林楷翊. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

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
        
        //the homepage button
        let signInButton = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.addTarget(nil, action: #selector(FirstViewController.goLogin),for: .touchUpInside)
        signInButton.backgroundColor = UIColor.lightGray
        signInButton.layer.cornerRadius = 5
        signInButton.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.6)
        self.view.addSubview(signInButton)
        
        // 建立前往 Intro 頁面的 UIButton
        let guestButton = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        guestButton.setTitle("Continue as Guest", for: .normal)
        guestButton.addTarget(nil, action: #selector(FirstViewController.goLogin_guest),for: .touchUpInside)
        guestButton.backgroundColor = UIColor.lightGray
        guestButton.layer.cornerRadius = 5
        guestButton.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.7)
        self.view.addSubview(guestButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn){
            //with segue identifier ID
            self.performSegue(withIdentifier: "homeView", sender: self)
        }
    }
    
    func goLogin(){
        self.performSegue(withIdentifier: "goLoginPage", sender: self)
    }
    
    func goLogin_guest(){
        self.performSegue(withIdentifier: "homeView", sender: self)
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
