//
//  BigPhotoViewController.swift
//  CamaraPhoto
//
//  Created by Kyle on 7/11/16.
//  Copyright © 2016 Alphacamp. All rights reserved.
//

import UIKit
import Photos

class BigPhotoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var BigPhotoImageView: UIImageView!
    
    var thePhotoChoose: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(thePhotoChoose)
        
        PHImageManager.defaultManager().requestImageForAsset(thePhotoChoose!, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: nil) { (image:UIImage?, info:[NSObject : AnyObject]?) in

            self.BigPhotoImageView.image = image
        
        }  // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: AnyObject) {
    
         self.dismissViewControllerAnimated(true, completion: nil)
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
