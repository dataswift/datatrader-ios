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

import Foundation

// MARK: Struct

/// A struct used to store the notification names of the notifications sent through the app
internal struct NotificationNamesConstants {
    
    // MARK: - Variables
    
    static let reauthorisedUser: Notification.Name = Notification.Name("reauthorisedUser")
    static let dataPlugMessage: Notification.Name = Notification.Name("dataPlugMessage")
    static let notificationHandlerName: Notification.Name = Notification.Name("notificationHandlerName")
    static let refreshAppStatus: Notification.Name = Notification.Name("refreshAppStatus")
    static let dataDebitAccepted: Notification.Name = Notification.Name("dataDebitAccepted")
    static let dataDebitFailure: Notification.Name = Notification.Name("dataDebitFailure")
}
