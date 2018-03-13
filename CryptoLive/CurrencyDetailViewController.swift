//
//  CurrencyDetailViewController.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-05.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import UIKit
import Alamofire
import Charts


class CurrencyDetailViewController: UIViewController, ChartViewDelegate{
    @IBOutlet weak var segmentDataControl: UISegmentedControl!
     
    @IBOutlet weak var last24hChangeLabel: UILabel!
    @IBOutlet weak var totalSupplyLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var priceBTCLabel: UILabel!
    @IBOutlet weak var priceUSDLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet  var candleStickChart: CandleStickChartView!
    var currencySymbol : String!
    var currencyObj : CurrencyModel!
    let currentCurrency = "USD"
    let currentLimit = 10
    var allHistoricalData = [HistoricDataModel]()
    var xAxisLabels = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyNameLabel.text = currencyObj.name
        currencySymbolLabel.text = currencyObj.symbol
        rankLabel.text = "Rank : \(currencyObj.rank)"
        priceUSDLabel.text = "Price (USD) : \(currencyObj.price_usd)"
        priceBTCLabel.text = "Price (BTC) : \(currencyObj.price_btc)"
        marketCapLabel.text = "Market Capitalization (USD) : \(currencyObj.market_cap_usd)"
        totalSupplyLabel.text = "Total Supply : \(currencyObj.total_supply)"
        last24hChangeLabel.text = "Last 24 hours : \(currencyObj.percent_change_24h)%"
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        print(currencySymbol)
        fetchHistoricalData(downloadURL:  URL(string : HISTORICAL_DATA_BASE_URL + self.currencySymbol + URL_CURRENCY + self.currentCurrency + URL_LIMIT + "\(self.currentLimit)")!) {
            for i in self.allHistoricalData{
                    //print(i.high + " " + i.low + " " + i.open + " " + i.close)
                self.xAxisLabels.append(i.timestamp)
                self.configureChart()
                self.candleStickChartUpdate()
            }
            
        }

        // Do any additional setup after loading the view.
    }

    
    @IBAction func onPressBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchHistoricalData(downloadURL : URL , completed : @escaping downloadHistoricData){
        
        let currentCryptoURL = downloadURL
       
        Alamofire.request(currentCryptoURL).responseJSON { (response) in
            //print(response)
            if let dict = response.value as? Dictionary<String, AnyObject>{
                if let data = dict["Data"] as? [Dictionary<String, AnyObject>]{
                    for instantMinuteData in data {
                        let instantData = HistoricDataModel(instantData : instantMinuteData)
                    self.allHistoricalData.append(instantData)
                    }
                }
            }
            completed()
        }
        
    }
    @IBAction func onDataSegmentChange(_ sender: Any) {
        
        if segmentDataControl.selectedSegmentIndex == 0 {
            let downloadURL =  URL(string : HISTORICAL_DATA_BASE_URL + self.currencySymbol + URL_CURRENCY + self.currentCurrency + URL_LIMIT + "\(self.currentLimit)")!
            self.allHistoricalData.removeAll()
            self.xAxisLabels.removeAll()
            fetchHistoricalData(downloadURL: downloadURL, completed: {
                
                for i in self.allHistoricalData{
                    //print(i.high + " " + i.low + " " + i.open + " " + i.close)
                    
                    self.xAxisLabels.append(i.timestamp)
                    self.configureChart()
                    self.candleStickChartUpdate()
                }
            })
        }
        
        if segmentDataControl.selectedSegmentIndex == 1 {
            let downloadURL =  URL(string : HISTORICAL_DATA_HOURLY_BASE_URL + self.currencySymbol + URL_CURRENCY + self.currentCurrency + URL_LIMIT + "\(self.currentLimit)")!
            self.allHistoricalData.removeAll()
            self.xAxisLabels.removeAll()
            fetchHistoricalData(downloadURL: downloadURL, completed: {
                for i in self.allHistoricalData{
                    print(i.high + " " + i.low + " " + i.open + " " + i.close)
                    self.xAxisLabels.append(i.timestamp)
                    self.configureChart()
                    self.candleStickChartUpdate()
                }
            })
        }
        
        if segmentDataControl.selectedSegmentIndex == 2 {
            let downloadURL =  URL(string : HISTORICAL_DATA_DAILY_BASE_URL + self.currencySymbol + URL_CURRENCY + self.currentCurrency + URL_LIMIT + "\(self.currentLimit)")!
            self.allHistoricalData.removeAll()
            self.xAxisLabels.removeAll()
            fetchHistoricalData(downloadURL: downloadURL, completed: {
                for i in self.allHistoricalData{
                    print(i.high + " " + i.low + " " + i.open + " " + i.close)
                    self.xAxisLabels.append(i.timestamp)
                    self.configureChart()
                    self.candleStickChartUpdate()
                }
            })
        }
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

extension CurrencyDetailViewController{
    
    func candleStickChartUpdate(){
        self.setDataCount()
    }
    
    func configureChart(){
        candleStickChart.delegate = self
        candleStickChart.chartDescription?.enabled = false
        candleStickChart.dragEnabled = false
        candleStickChart.setScaleEnabled(true)
        candleStickChart.maxVisibleCount = 200
        candleStickChart.pinchZoomEnabled = true
        candleStickChart.animate(xAxisDuration: 0, yAxisDuration: 1)
        candleStickChart.scaleXEnabled = true
        candleStickChart.scaleYEnabled = true
        candleStickChart.legend.horizontalAlignment = .right
        candleStickChart.legend.verticalAlignment = .top
        candleStickChart.legend.orientation = .vertical
        candleStickChart.legend.drawInside = false
        candleStickChart.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        //candleStickChart.data?.setValueTextColor(NSUIColor(white: 230/255, alpha: 1))
        candleStickChart.data?.setValueTextColor(NSUIColor(white: 230/255, alpha: 1))
        
        candleStickChart.noDataTextColor = UIColor(white:230/255, alpha: 1)
        candleStickChart.legend.textColor = UIColor(white: 230/255, alpha: 1)
        candleStickChart.leftAxis.labelFont = UIFont(name: "Helvetica", size: 7)!
        candleStickChart.leftAxis.labelTextColor = UIColor(white: 200/255, alpha: 1)
        candleStickChart.leftAxis.spaceTop = 0.3
        candleStickChart.leftAxis.spaceBottom = 0.3
        candleStickChart.rightAxis.enabled = false
        candleStickChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        candleStickChart.xAxis.labelPosition = .bothSided
        candleStickChart.xAxis.labelTextColor = UIColor(white: 230/255, alpha: 1)
        candleStickChart.xAxis.labelFont = UIFont(name: "Helvetica", size: 7)!
        
    }
    
    func setDataCount() {
        
        let yValues = (0..<currentLimit).map { (i) -> CandleChartDataEntry in
            let high = Double(allHistoricalData[i].high)!
            let low = Double (allHistoricalData[i].low)!
            let open = Double(allHistoricalData[i].open)!
            let close = Double(allHistoricalData[i].close)!
            return CandleChartDataEntry(x: Double(i), shadowH: high, shadowL: low, open: open, close: close, icon: UIImage(named: "icon")!)
        }
        
        
        let set1 = CandleChartDataSet(values: yValues, label: "Data Set")
        set1.axisDependency = .left
        set1.shadowColorSameAsCandle = true
        
        set1.setColor(UIColor(white: 200/255, alpha: 1))
        set1.drawIconsEnabled = false
        //set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 0/255, green: 230/255, blue: 118/255, alpha: 1)
        set1.increasingFilled = true
        set1.neutralColor = .blue
        let data = CandleChartData(dataSet: set1)
        candleStickChart.data = data
    }
}
