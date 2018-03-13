//
//  CurrencyModel.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-05.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import Foundation

class CurrencyModel{
    
    private var _symbol : String!
    private var _name : String!
    private var _price_usd : String!
    private var _price_btc : String!
    private var _market_cap_usd : String!
    private var _total_supply : String!
    private var _rank : String!
    private var _percent_change_24h : String!
    private var _last_updated : String!
    
    var symbol : String {
        if _symbol == nil{
            _symbol = ""
        }
        return _symbol
    }
    
    var name : String {
        if _name == nil{
            _name = ""
        }
        return _name
    }
    var price_usd : String {
        if _price_usd == nil{
            _price_usd = ""
        }
        return _price_usd
    }
    var price_btc : String {
        if _price_btc == nil{
            _price_btc = ""
        }
        return _price_btc
    }
    var market_cap_usd : String {
        if _market_cap_usd == nil{
            _market_cap_usd = ""
        }
        return _market_cap_usd
    }
    var total_supply : String {
        if _total_supply == nil{
            _total_supply = ""
        }
        return _total_supply
    }
    var rank : String {
        if _rank == nil{
            _rank = ""
        }
        return _rank
    }
    var percent_change_24h : String {
        if _percent_change_24h == nil{
            _percent_change_24h = ""
        }
        return _percent_change_24h
    }
    var last_updated : String {
        if _last_updated == nil{
            _last_updated = ""
        }
        return _last_updated
    }
    
    init(currencyDict : Dictionary<String, AnyObject>){
        
        if let symbol = (currencyDict["symbol"] as? String) {
            self._symbol = symbol
        }
       
        if let name = (currencyDict["name"] as? String){
            self._name = name
        }
        
        if let rank = (currencyDict["rank"] as? String){
            self._rank = rank
        }
        
        if let price_usd = currencyDict["price_usd"] as? String {
            self._price_usd = price_usd
        }
        
        if let price_btc = currencyDict["price_btc"] as? String {
            self._price_btc = price_btc
        }
        
        if let market_cap_usd = currencyDict["market_cap_usd"] as? String {
            self._market_cap_usd = market_cap_usd
        }
        
        if let total_supply = currencyDict["total_supply"] as? String {
            self._total_supply = total_supply
        }
        
        if let percent_change_24h = currencyDict["percent_change_24h"] as? String {
            self._percent_change_24h = percent_change_24h
        }
        
        if let last_updated = currencyDict["last_updated"] as? String {
            self._last_updated = last_updated
        }
        
    }
    
    
}
