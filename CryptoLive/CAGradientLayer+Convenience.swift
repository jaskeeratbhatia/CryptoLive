//
//  CAGradientLayer+Convenience.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-21.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func turquoiseColor() -> CAGradientLayer{
        let topColor  = UIColor(red: 15/255.0, green: 118/255.0, blue: 128/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 84/255.0, green: 187/255.0, blue: 187/255.0, alpha: 1.0)
        let gradientColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        return gradientLayer
        
    }
    
}
    
    extension UIViewController {
        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    }

extension UIImageView{
    
    func downloadImage(from imgurl : String){
        
        let urlRequest = URLRequest(url: URL(string: imgurl)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if(error != nil){
                
                print(error!)
                
                return
                
            }
            
            //Whenever u have to update the UI u have to do it in main thread, otherwise it will crash
            
            DispatchQueue.main.async {
                
                self.image = UIImage(data : data!)
                
            }
            
        }
        
        task.resume()
        
    }
    
}
   

