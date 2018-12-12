/**
 * Copyright (C) 2018 HAT Data Exchange Ltd
 *
 * SPDX-License-Identifier: MPL2
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

import HatForIOS
import Photos

// MARK: Class

/// A class responsible for handling the photo picker
internal class ImageManager: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// The photo picker delegate
    weak var delegate: PhotoPickerDelegate?
    /// The source type of the photo picker
    private var sourceType: UIImagePickerController.SourceType?
    
    /// A variable holding a reference to the image picker view used to present the photo library or camera
    private var imagePicker: UIImagePickerController?
    
    /// The album name to create
    private let albumName: String = "HAT"
    
    /// The asset collection
    private var assetCollection: PHAssetCollection?
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Check authorisation
    
    /**
     Checks if user has given permission to access photo library, if not ask permission
     */
    private func checkAuthorisation() {
        
        // get asset collection
        if let assetCollection: PHAssetCollection = fetchAssetCollectionForAlbum() {
            
            self.assetCollection = assetCollection
            return
        }
        
        // authorize
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            
            PHPhotoLibrary.requestAuthorization({ (_: PHAuthorizationStatus) -> Void in
                
                //status
            })
        }
        
        // if authorised create album else request authorasation
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
            self.createAlbum()
        } else {
            
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    // MARK: - Image picker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.imagePicker?.dismiss(animated: true, completion: nil)
        let image: UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        delegate?.didChooseImageWithInfo(info)
        
        if image != nil && self.sourceType == .camera {
            
            self.saveImage(image: image!)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            
            // we got back an error!
            let ac: UIAlertController = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func presentPicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        
        self.checkAuthorisation()
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        self.imagePicker?.sourceType = sourceType
        self.sourceType = sourceType
        
        if sourceType == .photoLibrary {
            
            self.imagePicker?.mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerController.SourceType.photoLibrary)!
        }
        
        return self.imagePicker!
    }
    
    // MARK: - Authorisation
    
    /**
     Request authorisation handler
     
     - parameter status: The returned authorisation status
     */
    private func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    // MARK: - Create album
    
    /**
     Creates an album in the photo library
     */
    private func createAlbum() {
        
        PHPhotoLibrary.shared().performChanges({
            
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)}) { success, error in
                
                if success {
                    
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                } else {
                    
                    print("error \(String(describing: error))")
                }
        }
    }
    
    // MARK: - Fetch collection
    
    /**
     Fetches the assetCollection for the specified album
     
     - returns: PHAssetCollection
     */
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        guard let firstObject: PHAssetCollection = collection.firstObject else {
            
            return nil
        }
        return firstObject
    }
    
    // MARK: - Save image
    
    /**
     Saves the image to the photo library
     
     - parameter image: The image to save to the photo library
     */
    func saveImage(image: UIImage) {
        
        guard let assetCollection: PHAssetCollection = self.assetCollection else {
            
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            
            let assetChangeRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder: PHObjectPlaceholder? = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest: PHAssetCollectionChangeRequest? = PHAssetCollectionChangeRequest(for: assetCollection)
            albumChangeRequest?.addAssets([assetPlaceHolder!] as NSArray)
        },
        completionHandler: nil)
    }
    
    // MARK: - Create action Sheet
    
    /**
     Creates an action sheet
     
     - parameter view: The BaseViewController to create an action sheet
     - parameter sourceRect: The rect of the view that requested the action sheet
     - parameter sourceView: The view that requested the action sheet
     */
    func createActionSheet(view: BaseViewController, sourceRect: CGRect, sourceView: UIView) {
        
        let alertController: UIAlertController = UIAlertController(title: "Choose Location", message: "Pick the source of the image", preferredStyle: .actionSheet)
        
        let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] action in
            
            weak var weakView = view
            guard let weakSelf = self else {
                
                return
            }
            
            let photoPickerContorller: UIImagePickerController = weakSelf.presentPicker(sourceType: .camera)
            weakView?.present(photoPickerContorller, animated: true, completion: nil)
        })
        
        let imageLibraryAction: UIAlertAction = UIAlertAction(title: "Image Library", style: .default, handler: { [weak self] action in
            
            weak var weakView = view
            guard let weakSelf = self else {
                
                return
            }
            
            let photoPickerContorller: UIImagePickerController = weakSelf.presentPicker(sourceType: .photoLibrary)
            weakView?.present(photoPickerContorller, animated: true, completion: nil)
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addActions(actions: [cameraAction, imageLibraryAction, cancelAction])
        alertController.addiPadSupport(sourceRect: sourceRect, sourceView: sourceView)
        
        view.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Downloads the profile image
     
     - parameter profile: The profile object
     - parameter imageView: The image view to show the downloaded image
     - parameter userToken: The user's token
     - parameter completion: A function to execute upon completion
     */
    class func downloadProfileImage(profile: HATProfileObject?, on imageView: UIImageView, userToken: String, completion: ((UIImage) -> Void)? = nil) {
        
        guard let avatarString = profile?.data.photo.avatar,
            let url = URL(string: avatarString) else {
                
                return
        }
        
        DispatchQueue.main.async {
            
            if imageView.image == UIImage(named: ImageNamesConstants.profilePlaceholder) {
                
                let image = UIImage(named: ImageNamesConstants.profilePlaceholder)
                imageView.image = image
                
                let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.addActivityIndicator(onView: imageView)
                
                imageView.downloadedFrom(url: url, userToken: userToken, progressUpdater: nil, completion: {
                    
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    imageView.cropImage(width: imageView.frame.width, height: imageView.frame.height)
                    completion?(imageView.image!)
                })
            }
        }
    }
    
}
