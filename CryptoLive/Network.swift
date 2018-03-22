//
//  Network.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-05.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import Foundation

public let ALL_COINS_URL = "https://api.coinmarketcap.com/v1/ticker/"
public let HISTORICAL_DATA_BASE_URL = "https://min-api.cryptocompare.com/data/histominute?fsym="
public let HISTORICAL_DATA_HOURLY_BASE_URL = "https://min-api.cryptocompare.com/data/histohour?fsym="
public let HISTORICAL_DATA_DAILY_BASE_URL = "https://min-api.cryptocompare.com/data/histoday?fsym="
public let URL_CURRENCY = "&tsym="
public let URL_LIMIT = "&limit="


typealias downloadAllCoinsData = () -> ()
typealias downloadHistoricData = () -> ()

public let ABOUT_US_TEXT = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. "


