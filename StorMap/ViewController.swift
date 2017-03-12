//
//  ViewController.swift
//  StorMap
//
//  Created by 林楷翊 on 03/03/2017.
//  Copyright © 2017 林楷翊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(!isUserLoggedIn){
            //with segue identifier ID
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "homeView", sender: self)

        }
    }

    @IBAction func logoutBtn(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
}

