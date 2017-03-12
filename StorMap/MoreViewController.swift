//
//  LoginViewController.swift
//  StorMap
//
//  Created by 林楷翊 on 12/03/2017.
//  Copyright © 2017 林楷翊. All rights reserved.
//

import UIKit
class MoreViewController: UIViewController {
    let fullScreenSize = UIScreen.main.bounds.size
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        UIImage(named: "bg1.png")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        //the homepage button
        let logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.backgroundColor = UIColor.lightGray
        logoutButton.addTarget(nil, action: #selector(MoreViewController.goLogout),for: .touchUpInside)
        logoutButton.layer.cornerRadius = 5
        logoutButton.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.6)
        self.view.addSubview(logoutButton)
        
        
        let headLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width * 0.8, height: 40))
        headLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.3)
        headLabel.textAlignment = .center
        headLabel.text = "More"
        self.view.addSubview(headLabel)
        
    }
    
    func goLogout(){
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
