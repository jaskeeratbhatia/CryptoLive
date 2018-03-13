//
//  CrytoCurrencyModelCell.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-07.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import UIKit
import LTMorphingLabel

class CrytoCurrencyModelCell: UITableViewCell {
    
    @IBOutlet weak var tradePrice: LTMorphingLabel!
    @IBOutlet weak var currencySymbol: LTMorphingLabel!
    @IBOutlet weak var currencyName: LTMorphingLabel!
    @IBOutlet weak var currencyIcon: UIImageView!
    
    func configureCell(name : String, symbol : String, price : String){
       
        self.currencyName.text = name
        self.currencySymbol.text = "(\(symbol))"
        self.tradePrice.text = "\(price) USD"
        self.currencyIcon.image = UIImage(named: "\(symbol.lowercased())")
    }

    @IBAction func onPressFavourites(_ sender: Any) {
    }
    @IBAction func onPressShare(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
