//
//  AboutUs.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-21.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import UIKit
import LTMorphingLabel

class AboutUs: UIViewController {
    @IBOutlet weak var aboutHeadingLabel: LTMorphingLabel!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var AboutText: LTMorphingLabel!
    @IBOutlet weak var seperatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutHeadingLabel.text = ""
        AboutText.text = ""
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        aboutView.layer.shadowColor = UIColor(white: 0.3, alpha: 0.5).cgColor
        aboutView.layer.shadowRadius = 10
        aboutView.layer.shadowOffset = CGSize(width: 5, height: 5)
        aboutView.layer.shadowOpacity = 0.8
        seperatorViewLeadingConstraint.constant = 500
        aboutViewHeightConstraint.constant = 0
       perform(#selector(loadAnimatedUI), with: nil, afterDelay: 0.5)

       
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc func loadAnimatedUI(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutHeadingLabel.text = "About"
            self.seperatorViewLeadingConstraint.constant = 20
            self.aboutViewHeightConstraint.constant = 300
            
            self.view.layoutIfNeeded()
        }) { (finished) in
            if(finished){

                UIView.transition(with: self.AboutText, duration: 0.7, options: .transitionCrossDissolve, animations: {
                    self.AboutText.text = ABOUT_US_TEXT
                }, completion: nil)
            }
        }
        
        
        
//        UIView.animate(withDuration: 0.5) {
//            self.aboutHeadingLabel.text = "About"
//            self.seperatorViewLeadingConstraint.constant = 20
//            self.aboutViewHeightConstraint.constant = 300
//            self.AboutText.text = ABOUT_US_TEXT
//            self.view.layoutIfNeeded()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressCancel(_ sender: Any) {
        self.aboutHeadingLabel.text = ""
        self.AboutText.text = ""
        self.navigationController?.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
