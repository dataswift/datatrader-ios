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

// MARK: Class

internal class ImagesViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoPickerDelegate {
    
    func didFinishWithError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    
    func didChooseImageWithInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
        
        func addFileToImages(file: FileUploadObject) {
            
            self.images.append(file)
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
        
        if let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
            
            HATFileService.uploadFileToHATWrapper(
                token: userToken,
                userDomain: userDomain,
                fileToUpload: image,
                tags: ["iphone", "viewer", "photo"],
                progressUpdater: nil,
                completion: {(file, renewedUserToken) in
                    
                    addFileToImages(file: file)
                    
                    // refresh user token
                    //KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: renewedUserToken)
                },
                errorCallBack: { [weak self] error in
                
                    self?.createDressyClassicOKAlertWith(alertMessage: "There was an error with the uploading of the file, please try again later", alertTitle: "Upload failed", okTitle: "OK", proceedCompletion: {})
                }
            )
        }
    }
    
    // MARK: - Variables
    
    private var images: [FileUploadObject] = []
    private var selectedImage: FileUploadObject?
    /// The Photo picker used to upload a new photo
    private let photoPicker: ImageManager = ImageManager()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newImageButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func newImageButtonAction(_ sender: Any) {
        
        self.photoPicker.createActionSheet(view: self, sourceRect: self.newImageButton.frame, sourceView: self.newImageButton)
    }
    
    // MARK: - View Controller functions

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.photoPicker.delegate = self
        
        self.setNavigationBarColorToDarkBlue()
        
        self.getImages()
        
        self.newImageButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionView Function
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedImage = self.images[indexPath.row]
        self.performSegue(withIdentifier: SeguesConstants.fullScreenImageSegue, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.imageCell, for: indexPath) as? ImagesCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.imageCell, for: indexPath)
        }
        
        return cell.setUpCell(
            image: self.images[indexPath.row],
            indexPath: indexPath,
            userToken: userToken,
            imageDownloaded: saveImageDownloaded)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth: CGFloat = self.collectionView.frame.width
        let widthWithCalculatedInsets: CGFloat = screenWidth - 20
        let width: CGFloat = widthWithCalculatedInsets / 3
        
        return CGSize(width: width, height: width)
    }
    
    // MARK: - Get Images
    
    private func getImages() {
        
        HATFileService.searchFiles(
            userDomain: userDomain,
            token: userToken,
            status: "Completed",
            name: "",
            tags: ["iphone"],
            successCallback: receivedImages,
            errorCallBack: receivedErrorGettingImages)
    }
    
    private func saveImageDownloaded(image: UIImage, indexPath: IndexPath) {
        
        self.images[indexPath.row].image = image
    }
    
    private func receivedImages(images: [FileUploadObject], newUserToken: String?) {
        
        self.images = images
        
        DispatchQueue.main.async { [weak self] in
            
            self?.collectionView.reloadData()
        }
    }
    
    private func receivedErrorGettingImages(error: HATError) {
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.destination is FullScreenImageViewController {
            
            weak var destinationVC = segue.destination as? FullScreenImageViewController
            
            destinationVC?.file = self.selectedImage
        }
    }

}
