//
//  TimelineTableViewController.swift
//  Meshitero
//
//  Created by 時武佑太 on 2014/09/28.
//  Copyright (c) 2014年 Yuta Tokitake. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var dataDesc: UILabel!
    @IBOutlet weak var fetchButton:UIButton?
    @IBOutlet weak var cameraButton: UIButton?
    
    var picker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        picker = UIImagePickerController()
        picker!.delegate = self
        picker!.allowsEditing = false
        
        self.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    
    func fetchData() {
        let query: PFQuery = PFQuery(className: "userPhoto")
        query.limit = 10
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                println(objects.description)
                self.dataDesc.text = objects.description
            } else {
                println(error.description)
            }
        })
    }
    
    @IBAction func fetch(sender: AnyObject) {
        self.fetchData()
    }
    
    @IBAction func startCamera(sender: AnyObject) {
        if picker == nil {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func showPhotoLibrary(sender: AnyObject) {
        if picker == nil {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        println( "imagePickerController" )
        self.dismissViewControllerAnimated(true, completion: nil)
        //imageView.image = image
        if picker!.sourceType == UIImagePickerControllerSourceType.Camera {
            println( "save photo" )
            UIImageWriteToSavedPhotosAlbum(image, self, "onSaveImageWithUIImage:error:contextInfo:", nil)
        } else if picker!.sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
            let q: CGFloat = CGFloat(0.05)
            let imageData: NSData! = UIImageJPEGRepresentation(image, q)
            self.uploadImage(imageData)
        }
    }
    
    func onSaveImageWithUIImage(image: UIImage!, error: NSErrorPointer, contextInfo: UnsafePointer<()>){
        if (error != nil) {
            println( "error" )
            return
        }
        println( "success" )
        
        let q: CGFloat = CGFloat(0.05)
        let imageData: NSData! = UIImageJPEGRepresentation(image, q)
        self.uploadImage(imageData)
    }
    
    func uploadImage(imageData: NSData!) {
        
        let imageFile = PFFile(name:"Image.jpg", data:imageData)
        
        imageFile.saveInBackgroundWithBlock({ (succeeded: Bool!, error: NSError!) -> Void in
            if (error == nil) {
                let userPhoto: PFObject = PFObject(className: "userPhoto")
                userPhoto.setObject(imageFile, forKey: "imageFile")
                
                //画像のアクセス権設定
                //userPhoto.ACL = PFACL.ACLWithUser(PFUser.currentUser())
                
                userPhoto.setObject(PFUser.currentUser(), forKey: "user")
                
                userPhoto.saveInBackgroundWithBlock({ (succeeded: Bool!, error: NSError!) -> Void in
                    if (error == nil) {
                        println("image uploaded")
                        self.fetchData()
                    } else {
                        println("error")
                        println(error.description)
                    }
                })
            } else {
                println("user error")
                println(error.description)
            }
        })
    }


    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
