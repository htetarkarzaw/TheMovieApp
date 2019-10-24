//
//  LoginViewController.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 25/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmailorPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    var iconClick = true
    
    let preference = UDHelper()
    
    var loginDelegate: LoginDelegate?
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let ui = UIActivityIndicatorView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.startAnimating()
        ui.style = UIActivityIndicatorView.Style.whiteLarge
        return ui
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignIn.layer.cornerRadius = 5
        btnSignIn.layer.borderColor = UIColor.gray.cgColor
        btnSignIn.layer.borderWidth = 1
        
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.stopAnimating()
        
    }
    
    @IBAction func clickShow(_ sender: Any) {
        if(iconClick == true) {
            tfPassword.isSecureTextEntry = false
        } else {
            tfPassword.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func clickSignin(_ sender: Any) {
        activityIndicator.startAnimating()
        
        fetchRequestToken()
    }
    
    fileprivate func fetchRequestToken() {
            
            if NetworkUtils.checkReachable() == false {
                Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
                activityIndicator.stopAnimating()
                return
            }
            
            ProfileModel.shared.fetchRequestToken { [weak self] requestToken in
                DispatchQueue.main.async { [weak self] in
                    
                    if requestToken.failure ?? false {
                        
                        self?.showToast(message: "Error connecting", font: UIFont.systemFont(ofSize: 13))
                        self?.activityIndicator.stopAnimating()
                        
                    } else {
                        
                        self?.initLogin(requestToken: requestToken.request_token ?? "")
                    }
                }
            }
        }
        
        fileprivate func initLogin(requestToken : String) {
            
            if tfEmailorPhone.text?.isEmpty ?? true {
                Dialog.showAlert(viewController: self, title: "Error", message: "Please enter email or phone")
                activityIndicator.stopAnimating()
            } else if tfPassword.text?.isEmpty ?? true {
                Dialog.showAlert(viewController: self, title: "Error", message: "Please enter password")
                activityIndicator.stopAnimating()
            } else {
                if NetworkUtils.checkReachable() == false {
                    Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
                    activityIndicator.stopAnimating()
                    return
                }
                
                ProfileModel.shared.fetchLoginValidate(username: tfEmailorPhone.text ?? "", password: tfPassword.text ?? "", requestToken: requestToken) { (response) in
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        if response.failure ?? false || response.request_token == "" || response.status_code == 30 {
                                                    
                            self?.showToast(message: "Incorrect username or password", font: UIFont.systemFont(ofSize: 13))
                            self?.activityIndicator.stopAnimating()
                            
                        } else {
                            
                            self?.fetchSessionId(requestToken: requestToken)
                            
                        }
                        
                    }
                    
                }
            }
        }
        
        fileprivate func fetchSessionId(requestToken : String) {
            
            if NetworkUtils.checkReachable() == false {
                Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
                activityIndicator.stopAnimating()
                return
            }
            
            ProfileModel.shared.fetchSessionByRequestToken(requestToken: requestToken) { (response) in
                
                DispatchQueue.main.async { [weak self] in
                    
                    if response.failure ?? false || response.session_id == "" {
                        
                        self?.showToast(message: "Something went wrong! pls try again later", font: UIFont.systemFont(ofSize: 13))
                        self?.activityIndicator.stopAnimating()
                        
                    } else {
                        
                        if response.session_id?.isEmpty ?? false {
                            self?.showToast(message: "Error saving login", font: UIFont.systemFont(ofSize: 13))
                        } else{
                            self?.loginDelegate?.onLoginSuccess()
                            self?.preference.saveSessionId(session_id: response.session_id ?? "")
                        }
                    }
                    self?.activityIndicator.stopAnimating()
                                    
                }
            }
        }
        
    }
