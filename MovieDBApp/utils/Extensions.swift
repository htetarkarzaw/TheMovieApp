//
//  Extensions.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import UIKit
extension UITableView{
    
    func registerForCell(strID : String) {
        register(UINib(nibName: strID, bundle: nil), forCellReuseIdentifier: strID)
    }
}

extension UICollectionView {

    func registerForCollectionCell(strID: String) {

        register(UINib(nibName: strID, bundle: nil), forCellWithReuseIdentifier: strID)
    }
}

extension UIViewController {
    
    func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    func updateView(viewController: UIViewController) {
        
        add(asChildViewController: viewController)
        
        /*
         if segmentedControl.selectedSegmentIndex == 0 {
         remove(asChildViewController: sessionsViewController)
         add(asChildViewController: summaryViewController)
         } else {
         remove(asChildViewController: summaryViewController)
         add(asChildViewController: sessionsViewController)
         }
         */
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-200, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 2
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func navigateToYoutubeVC(movieId: Int) {
       let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: MYoutubeViewController.identifier) as? MYoutubeViewController
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: MYoutubeViewController.self)) as? MYoutubeViewController
        vc?.movieId = movieId
        
        if let viewController = vc {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension UIImage {
    func blurred(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }
}
