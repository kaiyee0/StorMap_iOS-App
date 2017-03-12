//
//  MyStoryController.swift
//  StorMap
//
//  Created by 林楷翊 on 12/03/2017.
//  Copyright © 2017 林楷翊. All rights reserved.
//

import UIKit
class MyStoryViewController: UIViewController {
    let fullScreenSize = UIScreen.main.bounds.size
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        UIImage(named: "bg1.png")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        let headLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width * 0.8, height: 40))
        headLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.3)
        headLabel.textAlignment = .center
        headLabel.text = "Story"
        self.view.addSubview(headLabel)
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

