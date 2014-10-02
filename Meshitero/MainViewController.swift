//
//  ViewController.swift
//  Meshitero
//
//  Created by 時武佑太 on 2014/09/27.
//  Copyright (c) 2014年 Yuta Tokitake. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var button:UIButton?
    @IBOutlet weak var textField: UITextField!
    
    var picker: UIImagePickerController?
    var userName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        picker = UIImagePickerController()
        picker!.delegate = self
        picker!.allowsEditing = false
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_tile.png"))
        
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.Done
        textField.keyboardType = UIKeyboardType.ASCIICapable
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(sender: AnyObject) {
        if self.userName == nil || self.userName == "" {
            let alert: UIAlertView = UIAlertView(title: "エラー", message: "ユーザー名を入力してください", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        let currentUser: PFUser = PFUser()
        currentUser.username = self.userName
        currentUser.password = "password"
        
        PFUser.logInWithUsernameInBackground(self.userName, password: "password",
            block: { (user: PFUser!, error: NSError!) -> Void in
            
                if (error == nil) {
                    println(PFUser.currentUser().description)
                    self.performSegueWithIdentifier("ShowTimeline", sender: nil)
                    
                    let pushQuery: PFQuery = PFInstallation.query()
                    pushQuery.whereKey("deviceType", equalTo: "ios")
                    PFPush.sendPushMessageToQueryInBackground(pushQuery, withMessage: "ログインしました！")
                } else {
                    let alert: UIAlertView = UIAlertView(title: "エラー", message: "認証に失敗しました", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
        })
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        self.userName = textField.text
        textField.resignFirstResponder()
        return true
    }
    
}

