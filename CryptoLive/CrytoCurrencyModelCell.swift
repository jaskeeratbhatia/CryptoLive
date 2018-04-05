//
//  CrytoCurrencyModelCell.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-07.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import UIKit
import LTMorphingLabel
import FaveButton

class CrytoCurrencyModelCell: UITableViewCell {
    
    @IBOutlet weak var tradePrice: LTMorphingLabel!
    @IBOutlet weak var currencySymbol: LTMorphingLabel!
    @IBOutlet weak var currencyName: LTMorphingLabel!
    @IBOutlet weak var currencyIcon: UIImageView!
    @IBOutlet weak var shareButton: FaveButton!
    @IBOutlet weak var favouritesButton: FaveButton!
    weak var cellDelegate : CrytoCurrencyModelCellProtocol?
    
    
    func configureCell(name : String, symbol : String, price : String, isFavourite :Bool){
       
        self.currencyName.text = name
        self.currencySymbol.text = "(\(symbol))"
        self.tradePrice.text = "\(price) USD"
        self.currencyIcon.image = UIImage(named: "\(symbol.lowercased())")
        
        if isFavourite{
            favouritesButton.isSelected = true
        }
        else{
            favouritesButton.isSelected = false
        }
        shareButton.isSelected = true
    }

    @IBAction func onPressFavourites(_ sender: UIButton) {
        cellDelegate?.currencyTableCellDidTapHeart(sender.tag)
    }
    
    @IBAction func onPressShare(_ sender: UIButton) {
            cellDelegate?.currencyTableCellDidTapShare(sender.tag)
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
