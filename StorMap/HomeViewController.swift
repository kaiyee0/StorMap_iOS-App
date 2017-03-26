//
//  homeViewController.swift
//  StorMap
//
//  Created by 林楷翊 on 11/03/2017.
//  Copyright © 2017 林楷翊. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
/*
    override func viewDidLoad() {
        super.viewDidLoad()
        let fullScreenSize = UIScreen.main.bounds.size
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        UIImage(named: "bg1.png")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        let headLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width * 0.8, height: 40))
        headLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.3)
        headLabel.textAlignment = .center
        headLabel.text = "Home"
        self.view.addSubview(headLabel)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
    
    let fullsize = UIScreen.main.bounds.size
    let myUserDefaults = UserDefaults.standard
    var db :SQLiteConnect?
    let myFormatter = DateFormatter()
    var currentDate :Date = Date()
    
    var days :[String]! = []
    var myRecords :[String:[[String:String]]]! = [:]
    var currentMonthLabel :UILabel!
    var prevBtn :UIButton!
    var nextBtn :UIButton!
    var myTableView :UITableView!
    var selectedBackgroundView :UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Story"
        self.view.backgroundColor = UIColor.init(red: 0.092, green: 0.092, blue: 0.092, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        //UIImage(named: "bg1.png")?.draw(in: self.view.bounds)
        
        //database connect
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        db = SQLiteConnect(file: dbFileName)
        
        //setting btn on the nav bar
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings")!, style: .plain, target: self, action: #selector(HomeViewController.settingsBtnAction))
        
        currentMonthLabel = UILabel(frame: CGRect(x: 0, y: 100, width: fullsize.width * 0.7, height: 50))
        currentMonthLabel.center = CGPoint(x: fullsize.width * 0.5, y: 35)
        currentMonthLabel.textColor = UIColor.white
        myFormatter.dateFormat = "MM 月 dd 日"
        currentMonthLabel.text = myFormatter.string(from: currentDate)
        currentMonthLabel.textAlignment = .center
        currentMonthLabel.font = UIFont(name: "Helvetica Light", size: 32.0)
        currentMonthLabel.tag = 701
        self.view.addSubview(currentMonthLabel)
        
        //the previous day btn & the next day
        prevBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        prevBtn.center = CGPoint(x: fullsize.width * 0.1, y: 35)
        prevBtn.setImage(UIImage(named: "prev"), for: .normal)
        prevBtn.addTarget(self, action: #selector(HomeViewController.prevBtnAction), for: .touchUpInside)
        self.view.addSubview(prevBtn)
        
        nextBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        nextBtn.center = CGPoint(x: fullsize.width * 0.9, y: 35)
        nextBtn.setImage(UIImage(named: "next"), for: .normal)
        nextBtn.addTarget(self, action: #selector(HomeViewController.nextBtnAction), for: .touchUpInside)
        self.view.addSubview(nextBtn)
        
        
        let storyLabel = UILabel(frame: CGRect(x:0, y:70, width: fullsize.width * 0.5, height: 30))
        storyLabel.center = CGPoint(x: fullsize.width * 0.5, y: 70)
        storyLabel.textAlignment = .center
        storyLabel.font = UIFont(name: "Helvetica Light", size: 20.0)
        storyLabel.text = "My Story List"
        storyLabel.textColor = UIColor.white
        self.view.addSubview(storyLabel)
        
       
        myTableView = UITableView(frame: CGRect(x: 0, y: 105, width: fullsize.width, height: fullsize.height - 169) , style: .grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsSelection = true
        myTableView.backgroundColor = UIColor.black
        myTableView.separatorColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
        self.view.addSubview(myTableView)
        
        //click on the table cell
        selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: 44))
        selectedBackgroundView.backgroundColor = UIColor.init(red: 0.92, green: 0.92, blue: 0.8, alpha: 1)

        //add btn
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        addBtn.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height - 155)
        addBtn.addTarget(self, action: #selector(HomeViewController.addBtnAction), for: .touchUpInside)
        addBtn.setImage(UIImage(named:"add"), for: .normal)
        self.view.addSubview(addBtn)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let displaymonthDay = myUserDefaults.object(forKey: "displaymonthDay") as? String
        if displaymonthDay != nil && displaymonthDay != "" {
            myFormatter.dateFormat = "yyyy-MM-dd"
            currentDate = myFormatter.date(from: displaymonthDay!)!
            
            myUserDefaults.set("", forKey: "displaymonthDay")
            myUserDefaults.synchronize()
        }
        
        self.updateRecordsList()
    }
    
    
    func updateRecordsList() {
        myFormatter.dateFormat = "yyyy-MM-dd"
        let monthDay = myFormatter.string(from: currentDate)
        if let mydb = db {
            days = []
            myRecords = [:]
            
            let statement = mydb.fetch("records", cond: "monthDay == '\(monthDay)'", order: "createTime desc, id desc")
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = Int(sqlite3_column_int(statement, 0))
                let storyContent = String(cString: sqlite3_column_text(statement, 1))
                
                
                let storyTitle = String(cString: sqlite3_column_text(statement, 2))
                
                let createDate = String(cString: sqlite3_column_text(statement, 4))
                
                if createDate != "" {
                    if !days.contains(createDate) {
                        days.append(createDate)
                        myRecords[createDate] = []
                    }
                    
                    myRecords[createDate]?.append([
                        "id":"\(id)",
                        "storyContent":"\(storyContent)",
                        "storyTitle":"\(storyTitle)"
                        ])
                  
                }
                //print("!!!")
            }
            sqlite3_finalize(statement)
            
            myTableView.reloadData()
            
            myFormatter.dateFormat = "MM 月 dd 日"
            currentMonthLabel.text = myFormatter.string(from: currentDate)
        }
        
    }
    
    func updateCurrentDate(_ dateComponents :DateComponents) {
        let cal = Calendar.current
        let newDate = (cal as NSCalendar).date(byAdding: dateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))
        
        currentDate = newDate!
        
        self.updateRecordsList()
    }
    
    
    func prevBtnAction() {
        var dateComponents = DateComponents()
        dateComponents.day = -1
        self.updateCurrentDate(dateComponents)
    }
    
    func nextBtnAction() {
        var dateComponents = DateComponents()
        dateComponents.day = 1
        self.updateCurrentDate(dateComponents)
    }
    
    func settingsBtnAction() {
        self.navigationController?.pushViewController(MoreViewController(), animated: true)
    }
    
    func addBtnAction() {
        myUserDefaults.set(0, forKey: "postID")
        myUserDefaults.synchronize()
        
        self.navigationController?.pushViewController(AddViewController(), animated: false)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = days[section]
        guard let records = myRecords[date] else {
            return 0
        }
        //print(records.count)
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.textColor = UIColor.black
        cell!.detailTextLabel?.textColor = UIColor.black
        cell!.selectedBackgroundView = selectedBackgroundView
        
        let date = days[indexPath.section]
        guard let records = myRecords[date] else {
            return cell!
        }
        
        
        cell!.detailTextLabel?.text = records[indexPath.row]["storyContent"]
        cell!.textLabel?.text = records[indexPath.row]["storyTitle"]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let date = days[indexPath.section]
        guard let records = myRecords[date] else {
            return
        }
        
        myUserDefaults.set(Int(records[indexPath.row]["id"]!), forKey: "postID")
        myUserDefaults.synchronize()
        
        
        self.navigationController?.pushViewController(AddViewController(), animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    // section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days[section]
    }
    
    // section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // section footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (days.count - 1) == section ? 60 : 3
    }
    
    // section header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.init(red: 0.88, green: 0.83, blue: 0.73, alpha: 1)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
