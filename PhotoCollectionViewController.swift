//
//  PhotoCollectionViewController.swift
//  CamaraPhoto
//
//  Created by Kyle on 7/10/16.
//  Copyright © 2016 Alphacamp. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewController: UICollectionViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    @IBAction func CamaraButton(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            // Load camera interface
            
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
            
        } else {
            // No camera available
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (alertAction) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
    }
    
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet weak var contentLayout: UICollectionViewFlowLayout!

    var dateTime:AnyObject?
    let albumName = "PHPhoto Demo"
    var assetCollection : PHAssetCollection!
    var photosAsset : PHFetchResult!

    var albumFound : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let spacingWidth = Float(10)
        let width = (Float(UIScreen.mainScreen().bounds.width) - spacingWidth * Float(3 + 1)) / 3
        self.contentLayout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(width))
        
        self.setupAndCreateAsset()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnTap = false
        self.refreshPhotosAsset()
        self.photoCollectionView.reloadData()
        
    }
    
    
    
    func setupAndCreateAsset() {
        // Check if the folder exists, if not, create it.
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)

        let fetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if (fetchResult.firstObject != nil) {
            
            self.albumFound = true
            self.assetCollection = fetchResult.firstObject as! PHAssetCollection
            self.refreshPhotosAsset()
            
        } else {
            print("Folder \(albumName) does not exist. Creating now...")  // Folder false??
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                
                _ = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(self.albumName)
                
                }, completionHandler: { (success:Bool, error:NSError?) in
                    print("Creation of folder -> %@", success ? "Success" : "Error!")
                    
                    self.albumFound = success
                    self.setupAndCreateAsset()
            })
        }
    }
    
    func refreshPhotosAsset() {
        if self.assetCollection != nil {
            self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        var count = 0
        if self.photosAsset != nil {
            count = self.photosAsset.count
        }
        
        return count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhtoCollectionViewCell
        
        let asset = self.photosAsset[indexPath.item] as! PHAsset
       
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: nil) { (image:UIImage?, info:[NSObject : AnyObject]?) in
        
            cell.PotoImageView.image = image
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .LongStyle
            
            cell.phptoDate.text = "\(dateFormatter.stringFromDate(asset.creationDate!))"
            print("\(dateFormatter.stringFromDate(asset.creationDate!))")
            print("\(asset)")
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showBigPhotoSegue", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBigPhotoSegue"{
        
            let destinationViewController = segue.destinationViewController as! BigPhotoViewController
            destinationViewController.thePhotoChoose = self.photosAsset[sender!.item] as? PHAsset
            
        }
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       
    
    // Put image to image view
        let image : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var metadataDictionary: [NSObject : AnyObject] = (info[UIImagePickerControllerMediaMetadata] as! [NSObject : AnyObject])
        // do something with the metadata
        let meta = metadataDictionary["{Exif}"]
        dateTime = meta!["DateTimeDigitized"]
        
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
            
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset)
            
            
            let enumeration: NSArray = [assetPlaceholder!]
            albumChangeRequest?.addAssets(enumeration)
            
        }) { (result:Bool, error:NSError?) in
            
                dispatch_async(dispatch_get_main_queue(), {
                picker.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }


    
    
}
