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

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, OnboardingPageViewControllerDelegate {
    
    func updatePageControlIndex(_ index: Int) {
        
        self.pageControl.currentPage = index
    }
    
    func dismissPageViewController() {
        
        self.dismiss(animated: true, completion: { [weak self] in
            
            self?.completion?()
        })
        KeychainManager.setKeychainValue(key: KeychainConstants.newUser, value: KeychainConstants.Values.setFalse)
    }
    
    func nextViewController() {
        
        self.goToNextPage(animated: true, completion: nil)
    }
    
    var completion: (() -> Void)?
    var dynamicViewControllers: [OnboardingViewController]?

    private lazy var orderedViewControllers: [UIViewController] = {
        
        return [self.newVc(viewController: "firstOnboardingScreen"),
                self.newVc(viewController: "secondOnboardingScreen"),
                self.newVc(viewController: "thirdOnboardingScreen")]
    }()
    private var pageControl = UIPageControl()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.orderedViewControllers.index(of: viewController) else {
            
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // in order to not loop
        guard previousIndex >= 0 else {
            
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // in order to not loop
        guard orderedViewControllersCount != nextIndex else {
            
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    // MARK: Delegate functions
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
                
        if dynamicViewControllers != nil {
            
            // This sets up the first view that will show up on our page control
            if let firstViewController = dynamicViewControllers!.first {
                
                
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
                self.configurePageControl(count: self.dynamicViewControllers!.count)
                
                self.orderedViewControllers = dynamicViewControllers!
            }
        } else {
            
            // This sets up the first view that will show up on our page control
            if let firstViewController = orderedViewControllers.first {
                
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
                self.configurePageControl(count: self.orderedViewControllers.count)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .default
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    private func newVc(viewController: String) -> UIViewController {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController) as? OnboardingViewController else {
            
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
        }
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        
        return vc
    }
    
    func configurePageControl(count: Int) {
        
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.midX - 40, y: UIScreen.main.bounds.maxY - 40, width: 80, height: 13))
        self.pageControl.numberOfPages = count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.pageControlSelectedColor
        self.pageControl.pageIndicatorTintColor = UIColor.pageControlColor
        self.pageControl.currentPageIndicatorTintColor = UIColor.pageControlSelectedColor
        self.view.addSubview(pageControl)
    }
    
    // MARK: - Set up onboarding screens
    
    class func setupOnboardingScreens(onboardingScreens: [HATExternalAppsSetupOnboardingObject], from viewController: UIViewController, completion: (() -> Void)?) {
        
        guard !onboardingScreens.isEmpty else { return }
        
        // get the next view controller
        let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
        if let pageViewController: OnboardingPageViewController = mainStoryboard.instantiateViewController(withIdentifier: "launchOnboarding") as? OnboardingPageViewController {
            
            pageViewController.completion = completion
            
            var arrayOfViewControllers: [OnboardingViewController] = []
            for (index, screen) in onboardingScreens.enumerated() {
                
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newFirstOnboardingScreen") as? FirstOnboardingViewController else {
                    
                    break
                }
                vc.modalPresentationStyle = .fullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                vc.titleToShow = screen.title
                vc.descriptionToShow = screen.description
                vc.pageNumber = index
                vc.imageURL = screen.illustration.normal
                
                if index == onboardingScreens.count - 1 {
                    
                    vc.isFinalPage = true
                } else {
                    
                    vc.isFinalPage = false
                }
                vc.delegate = pageViewController
                arrayOfViewControllers.append(vc)
            }
            
            pageViewController.dynamicViewControllers = arrayOfViewControllers
            // present the next view controller
            viewController.present(pageViewController, animated: true, completion: nil)
        }
    }

}
