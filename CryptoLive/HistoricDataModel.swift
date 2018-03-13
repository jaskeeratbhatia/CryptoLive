//
//  HistoricDataModel.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-06.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import Foundation

class HistoricDataModel{
    
    private var _timestamp : String!
    private var _open : String!
    private var _close : String!
    private var _high : String!
    private var _low : String!
    
    var timestamp : String {
        if _timestamp == nil {
            _timestamp = ""
        }
        return _timestamp
    }
    var open : String {
        if _open == nil {
            _open = ""
        }
        return _open
    }
    var high : String {
        if _high == nil {
            _high = ""
        }
        return _high
    }
    var close  : String {
        if _close == nil {
            _close = ""
        }
        return _close
    }
    var low : String {
        if _low == nil {
            _low = ""
        }
        return _low
    }
    
    init(instantData : Dictionary<String, AnyObject>){
        if let high = instantData["high"] as? Double {
            self._high = "\(high)"
        }
        if let low = instantData["low"] as? Double {
            self._low = "\(low)"
        }
        if let open = instantData["open"] as? Double {
            self._open = "\(open)"
        }
        if let close = instantData["close"] as? Double {
            self._close = "\(close)"
        }
        if let timestamp = instantData["time"] as? Double {
            
            self._timestamp = timeOnlyFormatter(timestamp: timestamp)
        }
    }
    
    func timeOnlyFormatter(timestamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM d, h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        let time = dateFormatter.string(from: date)
        return time
    }
    
//    func dateOnlyFormatter(timestamp : Double) -> String {
//        let date = Date(timeIntervalSince1970: timestamp)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .none
//        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
//        let dateOnly = dateFormatter.string(from: date)
//        return dateOnly
//    }
}
