//
//  homeViewController.swift
//  StorMap
//
//  Created by 林楷翊 on 11/03/2017.
//  Copyright © 2017 林楷翊. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    struct Record {
        var id :Int = 0
        var storyContent :String?
        var storyTitle :String?
        var monthDay :String?
        var createDate :String?
        var createTime :String?
    }
    
    let fullsize = UIScreen.main.bounds.size
    let myUserDefaults = UserDefaults.standard
    var db :SQLiteConnect?
    let myFormatter = DateFormatter()
    var myDatePicker :UIDatePicker!
    var record :Record!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordId = myUserDefaults.object(forKey: "postID") as! Int
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        
        self.title = "Add Post"
        self.view.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        let height :CGFloat = 44.0
        let padding :CGFloat = 10.0
        
        db = SQLiteConnect(file: dbFileName)
        
        if let mydb = db {
            //get the data
            myFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            record = Record(id: 0, storyContent: nil, storyTitle: nil, monthDay: nil, createDate: nil, createTime: myFormatter.string(from: Date()))
            
            if recordId > 0 {
                self.title = "Update"
                let statement = mydb.fetch("records", cond: "id == \(recordId)", order: nil)
                if sqlite3_step(statement) == SQLITE_ROW{
                    record.id = Int(sqlite3_column_int(statement, 0))
                    record.storyContent = String(cString: sqlite3_column_text(statement, 1))
                    
                    record.storyTitle = String(cString: sqlite3_column_text(statement, 2))
                    record.createTime = String(cString: sqlite3_column_text(statement, 5))
                    
                }
                sqlite3_finalize(statement)
            }
            
            // title input
            var myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 0.3, width: fullsize.width, height: height))
            myTextField.keyboardType = .default
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .right
            myTextField.textColor = UIColor.white
            myTextField.font = UIFont(name: "Helvetica Light", size: 24.0)
            myTextField.attributedPlaceholder = NSAttributedString(string: "Story Title", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            myTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
            myTextField.rightViewMode = .always
            myTextField.tag = 101
            myTextField.returnKeyType = .next
            myTextField.delegate = self
            if let str = record.storyContent {
                myTextField.text = str
            }
            self.view.addSubview(myTextField)
            
            //story input
            myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 1.6, width: fullsize.width, height: height))
            myTextField.keyboardType = .default
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .right
            myTextField.textColor = UIColor.white
            myTextField.font = UIFont(name: "Helvetica Light", size: 24.0)
            myTextField.attributedPlaceholder = NSAttributedString(string: "Story", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            myTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
            myTextField.rightViewMode = .always
            myTextField.tag = 102
            myTextField.returnKeyType = .next
            myTextField.delegate = self
            if let str = record.storyTitle {
                myTextField.text = str
            }
            self.view.addSubview(myTextField)
            
            // date input
            myTextField = UITextField(frame: CGRect(x: 0.0, y: height * 2.9, width: fullsize.width, height: height))
            myTextField.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            myTextField.textAlignment = .center
            myTextField.textColor = UIColor.white
            myTextField.font = UIFont(name: "Helvetica Light", size: 32.0)
            myTextField.text = record.createTime
            myTextField.tag = 103
            self.view.addSubview(myTextField)
            
            // UIDatePicker
            myDatePicker = UIDatePicker()
            myDatePicker.datePickerMode = .dateAndTime
            myDatePicker.locale = Locale(identifier: "zh_TW")
            myDatePicker.date = myFormatter.date(from: record.createTime!)!
            myTextField.inputView = myDatePicker
            
            // UIDatePicker 取消及完成按鈕
            let toolBar = UIToolbar()
            toolBar.barTintColor = UIColor.clear
            toolBar.sizeToFit()
            toolBar.barStyle = .default
            toolBar.tintColor = UIColor.white
            let cancelBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(AddViewController.cancelTouched(_:)))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let doneBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(AddViewController.doneTouched(_:)))
            toolBar.items = [cancelBtn, space, doneBtn]
            myTextField.inputAccessoryView = toolBar
            
            // save btn
            let saveBtn = UIButton(frame: CGRect(x: 0.0, y: height * 4.2, width: fullsize.width, height: height * 1.5))
            saveBtn.setTitle("Save", for: .normal)
            saveBtn.setTitleColor(UIColor.black, for: .normal)
            saveBtn.backgroundColor = UIColor.init(red: 0.88, green: 0.83, blue: 0.73, alpha: 1)
            saveBtn.addTarget(self, action: #selector(AddViewController.saveBtnAction), for: .touchUpInside)
            self.view.addSubview(saveBtn)
            
            // delete btn
            if record.id != 0 {
                let deleteBtn = UIButton(frame: CGRect(x: 5.0, y: height * 5.8, width: 50, height: height))
                deleteBtn.setTitle("Delete", for: .normal)
                deleteBtn.setTitleColor(UIColor.red, for: .normal)
                deleteBtn.addTarget(self, action: #selector(AddViewController.deleteBtnAction), for: .touchUpInside)
                self.view.addSubview(deleteBtn)
            }
            
        }
        
        let tap = UITapGestureRecognizer(target: self,action:#selector(AddViewController.hideKeyboard(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    func deleteBtnAction() {
        let alertController = UIAlertController(title: "Delete", message: "Delete Confirmed？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Delete", style: .default, handler: {
            (result) -> Void in
            if let mydb = self.db {
                _ = mydb.delete("records", cond: "id = \(self.record.id)")
            }
            
            _ = self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(okAction)
        
        self.present(alertController,animated: false,completion:nil)
        
    }
    
    func saveBtnAction() {
        var textField = self.view.viewWithTag(101) as! UITextField
        record.storyTitle = textField.text ?? ""
        
        textField = self.view.viewWithTag(102) as! UITextField
        record.storyContent = textField.text ?? ""
        
        if record.storyContent != "" {
            record.monthDay = (record.createTime! as NSString).substring(from: 5)
            record.monthDay = (record.createTime! as NSString).substring(to: 10)
            
            record.createDate = (record.createTime! as NSString).substring(to: 10)
            
            if let mydb = db {
                let rowInfo = [
                    "storyContent":"'\(record.storyContent!)'",
                    "storyTitle":"'\(record.storyTitle!)'",
                    "monthDay":"'\(record.monthDay!)'",
                    "createDate":"'\(record.createDate!)'",
                    "createTime":"'\(record.createTime!)'"
                ]
                
                if record.id > 0 {
                    _ = mydb.update("records", cond: "id = \(record.id)", rowInfo:rowInfo)
                } else {
                    _ = mydb.insert("records", rowInfo:rowInfo )
                    print("success!!")
                    print(rowInfo)
                }
                myUserDefaults.set(record.monthDay!, forKey: "displaymonthDay")
                myUserDefaults.synchronize()
                
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func doneTouched(_ sender:UIBarButtonItem) {
        let textField = self.view.viewWithTag(103) as! UITextField
        let date = myFormatter.string(from: myDatePicker.date)
        textField.text = date
        record.createTime = date
        
        hideKeyboard(nil)
    }
    
    func cancelTouched(_ sender:UIBarButtonItem) {
        hideKeyboard(nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let storyContent = self.view.viewWithTag(102) as! UITextField
        let date = self.view.viewWithTag(103) as! UITextField
        
        storyContent.resignFirstResponder()
        date.becomeFirstResponder()
        
        return true
    }
    
    
    
    
    func hideKeyboard(_ tapG:UITapGestureRecognizer?){
        self.view.endEditing(true)
    }
    
}
