//
//  BaseViewController.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//
import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func showAlertDialog(message: String){
        let alert = UIAlertController(title: "Fail", message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension BaseViewController : NVActivityIndicatorViewable{
    func showProgress(message : String){
        startAnimating(CGSize(width: 30, height: 30), message: message, type: NVActivityIndicatorType.ballClipRotateMultiple)
    }
    
    func hideProgress(){
        stopAnimating()
    }
}
