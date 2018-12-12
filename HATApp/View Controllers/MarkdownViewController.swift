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

import MarkdownView
import SafariServices

// MARK: Class

internal class MarkdownViewController: BaseViewController {
    
    // MARK: - Variables
    
    /// A safari reference for opening links on it
    private var safari: SFSafariViewController?
    /// The markdown file url
    var url: String = TermsURL.termsAndConditions
    
    // MARK: - Markdown view
    
    /// An IBoutlet for handling the markdown UIView
    @IBOutlet private weak var markdownView: MarkdownView!
    
    // MARK: - View Controller functions

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.showMarkDown()
        
        self.setNavigationBarColorToDarkBlue()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Show markdown file
    
    /**
     Shows the markdown file on screen
     */
    private func showMarkDown() {
        
        self.getMarkDownFile()
        
        self.addTouchLinkSupport()
    }
    
    // MARK: - Add support for touchable links
    
    /**
     Adds support for touchable links
     */
    private func addTouchLinkSupport() {
        
        self.markdownView.onTouchLink = { [weak self] request in
            
            guard let url: URL = request.url, let weakSelf: MarkdownViewController = self else {
                
                return false
            }
            
            if url.scheme == "file" {
                
                return true
            } else if url.scheme == "https" {
                
                weakSelf.safari = SFSafariViewController.openInSafari(url: String(describing: url), on: weakSelf, animated: true, completion: nil)
                
                return false
            }
            
            return false
        }
    }
    
    // MARK: - Get markdown file
    
    /**
     Constructs the url and gets the md file
     */
    private func getMarkDownFile() {
        
        guard let url: URL = URL(string: self.url) else {
            
            return
        }
        
        let session: URLSession = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, _, _ in
            
            guard let data: Data = data else {
                
                return
            }
            
            let str: String? = String(data: data, encoding: String.Encoding.utf8)
            DispatchQueue.main.async {
                
                self?.markdownView.load(markdown: str)
            }
        }.resume()
    }
}
