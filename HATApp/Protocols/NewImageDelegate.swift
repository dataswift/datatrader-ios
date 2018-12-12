//
//  NewImageDelegate.swift
//  ShapeInfluence
//
//  Created by Marios-Andreas Tsekis on 5/11/17.
//  Copyright © 2017 Marios-Andreas Tsekis. All rights reserved.
//

import UIKit

protocol NewImageDelegate {
    
    // MARK: - Protocol's functions
    
    /**
     A function to execute when image has being selected
     
     - parameter info: A dictionary of type <String, Any> containing info about the selected image
     */
    func didChooseImageWithInfo(_ info: [String : Any])
    
    /**
     A function to execute when there is an error selecting an image
     
     - parameter image: The UIImage that produced the error
     - parameter error: The actual error
     - parameter contextInfo: Some more info about the error
     */
    func didFinishWithError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
}
