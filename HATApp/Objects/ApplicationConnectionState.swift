//
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

// MARK: ApplicationConnectionState

enum ApplicationConnectionState: String {
    
    // MARK: - Possible cases
    
    case connected
    case notConnected
    case failing
    case fetching
    case needsUpdating
    case unavailable
    
    // MARK: - Get state
    
    static func getState(application: HATApplicationObject) -> ApplicationConnectionState {
        
        if application.setup && (application.needsUpdating ?? false) {
            
            return .needsUpdating
        } else if application.enabled && !application.active {
            
            return .failing
        } else if application.enabled && application.active {
            
            if application.mostRecentData == nil && application.application.kind.kind != "App" {
                
                return .fetching
            }
            
            return .connected
        }
        
        return .notConnected
    }
    
    static func getState(tool: HATToolsObject) -> ApplicationConnectionState {
        
        
        if tool.status.available && tool.status.enabled {
            
            return .connected
        } else if !tool.status.available {
            
            return .unavailable
        }
        
        return .notConnected
    }
    
    // MARK: - Update button
    
    static func updateButton(_ button: UIButton, basedOn application: HATApplicationObject) {
        
        let status = ApplicationConnectionState.getState(application: application)
        
        ApplicationConnectionState.updateButton(button, basedOn: status, andType: application.application.kind.kind)
    }
    
    static func updateButton(_ button: UIButton, basedOn status: ApplicationConnectionState, andType type: String) {
        
        switch status {
        case .connected:
            
            if type == "App" {
                
                let image = UIImage(named: ImageNamesConstants.goToApp)
                
                button.backgroundColor = .selectionColor
                button.setImage(image, for: .normal)
                button.setTitle("OPEN APP", for: .normal)
                button.setTitleColor(.white, for: .normal)
            } else {
                
                let image = UIImage(named: ImageNamesConstants.checkmark)
                
                button.backgroundColor = .clear
                button.layer.borderColor = UIColor.selectionColor.cgColor
                button.layer.borderWidth = 1
                button.setImage(image, for: .normal)
                button.setTitle("ACTIVE", for: .normal)
                button.setTitleColor(.selectionColor, for: .normal)
            }
        case .failing:
            
            let image = UIImage(named: ImageNamesConstants.reconnect)
            button.setImage(image, for: .normal)
            button.setTitle("RECONNECT", for: .normal)
            button.backgroundColor = .hatPasswordRed
            button.setTitleColor(.white, for: .normal)
        case .fetching:
            
            let image = UIImage(named: ImageNamesConstants.fetching)
            button.setImage(image, for: .normal)
            button.backgroundColor = .clear
            button.setTitle("FETCHING...", for: .normal)
            button.setTitleColor(.selectionColor, for: .normal)
        case .notConnected:
            
            let image = UIImage(named: ImageNamesConstants.addWhite)
            button.setImage(image, for: .normal)
            button.setTitle("CONNECT", for: .normal)
            button.backgroundColor = .selectionColor
            button.setTitleColor(.white, for: .normal)
        case .needsUpdating:
            
            let image = UIImage(named: ImageNamesConstants.reconnect)
            button.setImage(image, for: .normal)
            button.setTitle("UPDATE", for: .normal)
            button.backgroundColor = .hatPasswordOrange
            button.setTitleColor(.white, for: .normal)
        case .unavailable:
            
            let image = UIImage(named: ImageNamesConstants.unavailable)
            button.setImage(image, for: .normal)
            button.backgroundColor = .clear
            button.setTitle("UNAVAILABLE", for: .normal)
            button.setTitleColor(.hatDisabled, for: .normal)
        }
    }
    
    static func updateStatusCellButton(_ button: UIButton, basedOn application: HATApplicationObject) {
        
        let status = ApplicationConnectionState.getState(application: application)
        
        ApplicationConnectionState.updateStatusCellButton(button, basedOn: status)
    }
    
    static func updateStatusCellButton(_ button: UIButton, basedOn status: ApplicationConnectionState) {
        
        switch status {
        case .connected:
            
            let image = UIImage(named: ImageNamesConstants.checkmark)
            button.setImage(image, for: .normal)
        case .failing:
            
            let image = UIImage(named: ImageNamesConstants.reconnectRed)
            button.setImage(image, for: .normal)
        case .fetching:
            
            let image = UIImage(named: ImageNamesConstants.fetching)
            button.setImage(image, for: .normal)
        case .notConnected:
            
            let image = UIImage(named: ImageNamesConstants.add)
            button.setImage(image, for: .normal)
        case .needsUpdating:
            
            let image = UIImage(named: ImageNamesConstants.reconnectRed)
            button.setImage(image, for: .normal)
        case .unavailable:
            
            button.setImage(nil, for: .normal)
        }
    }
    
    static func updateLabel(_ label: UILabel, basedOn application: HATApplicationObject) {
        
        let status = ApplicationConnectionState.getState(application: application)
        
        ApplicationConnectionState.updateLabel(label, basedOn: status)
    }
    
    static func updateLabel(_ label: UILabel, basedOn status: ApplicationConnectionState) {
        
        switch status {
            
        case .failing:
            
            label.text = "ERROR: Data Plug disconnected. Please tap reconnect to re-establish connection."
            label.textColor = .hatPasswordRed
        case .fetching:
            
            label.text = "Data Plug is fetching data. This can take a while. Please wait."
            label.textColor = .selectionColor
        case .needsUpdating:
            
            label.text = "There is an update. Please tap the update button above."
            label.textColor = .hatPasswordOrange
        default:
            
            label.text = ""
            label.textColor = .hatPasswordOrange
        }
    }
}
