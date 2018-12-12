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

import UIKit

// MARK: Extension

extension UIPageViewController {
    
    // MARK: - Go to Next Page

    /**
     Go to the next page of the UIPageViewController
     
     - parameter animated: Defines if the transition will be animated. Default is true
     - parameter completion: A function to execute after completing the transition
     */
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: completion)
    }
    
    // MARK: - Go to Previous Page
    
    /**
     Go to the previous page of the UIPageViewController
     
     - parameter animated: Defines if the transition will be animated. Default is true
     - parameter completion: A function to execute after completing the transition
     */
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: completion)
    }
}
