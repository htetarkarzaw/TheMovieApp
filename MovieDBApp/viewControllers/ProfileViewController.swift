//
//  ProfileViewController.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 25/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController ,LoginDelegate{

    func onLoginSuccess() {
            self.remove(asChildViewController: loginViewController)
            self.updateView(viewController: profileViewController)
        }
        
        lazy var loginViewController: LoginViewController = {
            // Load Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            // Instantiate View Controller
            var viewController = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
            
            viewController.loginDelegate = self
            
            // Add View Controller as Child View Controller
            self.add(asChildViewController: viewController)
            return viewController
        }()
        
        lazy var profileViewController: ProfileDetailViewController = {
            // Load Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            // Instantiate View Controller
            var viewController = storyboard.instantiateViewController(withIdentifier: String(describing: ProfileDetailViewController.self)) as! ProfileDetailViewController
            
            // Add View Controller as Child View Controller
            self.add(asChildViewController: viewController)
            return viewController
        }()
        

        let preference = UDHelper()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            if preference.getSessionId().isEmpty {
                self.updateView(viewController: loginViewController)
            } else {
                self.updateView(viewController: profileViewController)
            }
        }

    }
