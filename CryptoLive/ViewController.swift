//
//  ViewController.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-04.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import UIKit
import Alamofire
import LTMorphingLabel
import GearRefreshControl
import FaveButton
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CrytoCurrencyModelCellProtocol {
 
    @IBOutlet weak var sideMenuStackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuStackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuHeadingSeperatorViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuHeadingLabel: LTMorphingLabel!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var NavBarHeading: LTMorphingLabel!
    @IBOutlet weak var tableView: UITableView!
    var currencies = [CurrencyModel]()
    var filteredCurrencies = [CurrencyModel]()
    var gearRefreshControl: GearRefreshControl!
    var isSearchActive = false
    var localCurrencies = [FavouriteCurrency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencies = []
       self.view.bringSubview(toFront: self.sideMenuView)
        //tableView.backgroundColor = UIColor.clear
        sideMenuWidth.constant = self.view.frame.width/1.25
        blurView.layer.cornerRadius = 20
        sideMenuView.layer.shadowRadius = 8
        sideMenuView.layer.shadowOffset = CGSize(width: 10, height: 0)
        sideMenuView.layer.shadowColor = UIColor.black.cgColor
        sideMenuView.layer.shadowOpacity = 0.6
        sideMenuLeadingConstraint.constant = -self.view.frame.width/1.25
        sideMenuHeadingSeperatorViewTrailingConstraint.constant = 400
        sideMenuStackViewTrailingConstraint.constant = 400
        sideMenuStackViewLeadingConstraint.constant = -600
        
    
        NavBarHeading.text = "Crypto-Live"
        navigationController?.navigationBar.isHidden = true
        //To make the status bar text color white
        navigationController?.navigationBar.barStyle = .black
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        gearRefreshControl = GearRefreshControl(frame: (self.tableView.bounds))
        gearRefreshControl.gearTintColor = UIColor(white : 160/255, alpha:1)
        
        gearRefreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.refreshControl = gearRefreshControl
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    @objc func refresh(){
        self.NavBarHeading.text = "Crypto-Live"
        currencies = []
        //tableView.reloadData()
        navigationController?.navigationBar.isHidden = true
        
       
    
    downloadData {
        self.localCurrencies = DatabaseManager.shared.getAllFavourites()!
        for local in self.localCurrencies{
            let currencyIndex = self.currencies.index(where: { (currency)  in
                currency.symbol == local.currencySymbol
            })
            self.currencies[currencyIndex!]._isFavourite = true
        }
        
    print(self.currencies.count)
    //self.tableView.reloadData()
    let range = NSMakeRange(0, self.tableView.numberOfSections)
    let sections = NSIndexSet(indexesIn: range)
    self.tableView.isHidden = false
    self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    let popTime = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
    DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
    //self.tableView.refreshControl?.endRefreshing()
    self.gearRefreshControl.endRefreshing()
    
    }
    
    }
    }
    
    @IBAction func onCancelPress(_ sender: Any) {
        tableView.isUserInteractionEnabled = true
        searchBar.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.5) {
            self.sideMenuLeadingConstraint.constant = -self.view.frame.width/1.25
            self.sideMenuHeadingSeperatorViewTrailingConstraint.constant = 400
            self.sideMenuStackViewTrailingConstraint.constant = 400
            self.sideMenuStackViewLeadingConstraint.constant = -600
            self.view.layoutIfNeeded()
        }
        self.sideMenuHeadingLabel.text = ""
    }
    
    @IBAction func onPressOptions(_ sender: Any) {
        tableView.isUserInteractionEnabled = false
        searchBar.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuLeadingConstraint.constant = -20
            
            self.view.layoutIfNeeded()
        }) { (finished) in
            if (finished) {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.sideMenuHeadingLabel.text = "Cryto-Live"
                    self.sideMenuHeadingSeperatorViewTrailingConstraint.constant = 10
                    self.sideMenuStackViewLeadingConstraint.constant = 30
                    self.sideMenuStackViewTrailingConstraint.constant = 10
                    self.view.layoutIfNeeded()
                })
                
            }
        }
//        UIView.animate(withDuration: 0.5) {
//            self.sideMenuLeadingConstraint.constant = -20
//            self.sideMenuHeadingLabel.text = "Cryto-Live"
//
////            self.tableView.alpha = 0.1
////            self.searchBar.alpha = 0.1
////            self.navBarView.alpha = 0.1
//            self.view.layoutIfNeeded()
//
//        }
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gearRefreshControl.scrollViewDidScroll(self.tableView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil || searchBar.text == "")
        {
            isSearchActive = false
            view.endEditing(true)
        }
        else
        {
            isSearchActive = true
            let searchItem = searchBar.text!.lowercased()
            filteredCurrencies = currencies.filter({$0.name.lowercased().range(of: searchItem) != nil})
        }
        
        tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.NavBarHeading.text = "Crypto-Live"
        currencies = []
        //tableView.reloadData()
        navigationController?.navigationBar.isHidden = true
        localCurrencies =  DatabaseManager.shared.getAllFavourites()!
        print(localCurrencies)
        downloadData {
            self.localCurrencies = DatabaseManager.shared.getAllFavourites()!
            for local in self.localCurrencies{
                let currencyIndex = self.currencies.index(where: { (currency)  in
                    currency.symbol == local.currencySymbol
                })
                self.currencies[currencyIndex!]._isFavourite = true
            }
            
            print(self.currencies.count)
            //self.tableView.reloadData()
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.isHidden = false
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)
            
        }
    }
    
    func downloadData(completed :  @escaping downloadAllCoinsData)
    {
        Alamofire.request(URL(string : ALL_COINS_URL)!).responseJSON{
            response in
            
            //print(response)
            if let dict = response.value  as? [Dictionary<String,AnyObject>] {
                //print(dict)
                
                //self.localCurrencies = DatabaseManager.shared.getAllFavourites()!
                print("***************")
                print(self.localCurrencies)
                for currency in dict{
                    let newCurrency = CurrencyModel(currencyDict: currency)
                    
//                    let localCurrency = FavouriteCurrency()
//                    localCurrency.currencySymbol = (currency["symbol"] as? String)!
                    //print(localCurrency)
                    
                    
//                    if  self.localCurrencies.contains(localCurrency){
//                        newCurrency._isFavourite = true
//                        print("\(localCurrency.currencySymbol) is already Favourite")
//                    }
//                    else{
//                        //print("Nothing found")
//                    }
                    self.currencies.append(newCurrency)
                    
                }
            }
            else{
                print("dict not formatted")
            }
            completed()
        }
        
    }
    
    
    
    @IBAction func onClickSignOut(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        print("signout")
    }
    
}

extension ViewController  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchActive{
            return filteredCurrencies.count
        }
        
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CrytoCurrencyModelCell{
            
            cell.cellDelegate = self
            cell.tag = indexPath.row
            cell.favouritesButton.tag = indexPath.row
            cell.shareButton.tag   = indexPath.row
            //cell.favouritesButton.isSelected = false
            
            if isSearchActive{
                cell.configureCell(name: filteredCurrencies[indexPath.row].name, symbol: filteredCurrencies[indexPath.row].symbol, price: filteredCurrencies[indexPath.row].price_usd, isFavourite : filteredCurrencies[indexPath.row].isFavourite)
                return cell
            }
            else{
                cell.configureCell(name: currencies[indexPath.row].name, symbol: currencies[indexPath.row].symbol, price: currencies[indexPath.row].price_usd, isFavourite : currencies[indexPath.row].isFavourite)
            
                return cell
            }
            
        }
        else {
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "currencyDetail") as! CurrencyDetailViewController
        if isSearchActive{
            nextViewController.currencySymbol = filteredCurrencies[indexPath.row].symbol
            nextViewController.currencyObj = filteredCurrencies[indexPath.row]

        }
        else{
            nextViewController.currencySymbol = currencies[indexPath.row].symbol
            nextViewController.currencyObj = currencies[indexPath.row]
        }
        
        NavBarHeading.text = ""
        //self.tableView.isHidden = true
        navigationController?.pushViewController(nextViewController, animated: true)
        print("pushed")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.8,0.8,1)
        UIView.animate(withDuration: 0.6, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
//                UIView.animate(withDuration: 0.4, animations: {
//                    cell.layer.transform = CATransform3DMakeScale(1.5,1.5,1)
//                })
//                UIView.animate(withDuration: 0.2, animations: {
//                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
//                })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func currencyTableCellDidTapHeart(_ tag: Int) {
        if isSearchActive{
            let currSymbol = filteredCurrencies[tag].symbol
            let pos = currencies.index(where: { (currency)  in
                currency.symbol == currSymbol
            })
            if currencies[pos!].isFavourite{
                let localCurrency = FavouriteCurrency()
                localCurrency.currencySymbol = currencies[pos!].symbol
                DatabaseManager.shared.deletefromFavoutites(currency : localCurrency)
                }
            else{
                let localCurrency = FavouriteCurrency()
                localCurrency.currencySymbol = currencies[pos!].symbol
                DatabaseManager.shared.addtoFavourites(currency: localCurrency)
                }
            print(currencies[pos!].symbol)
        }
        else{
            if currencies[tag].isFavourite{
                let localCurrency = FavouriteCurrency()
                localCurrency.currencySymbol = currencies[tag].symbol
                print(localCurrency)
                DatabaseManager.shared.deletefromFavoutites(currency : localCurrency)
                }
            else{
                let localCurrency = FavouriteCurrency()
                localCurrency.currencySymbol = currencies[tag].symbol
                DatabaseManager.shared.addtoFavourites(currency: localCurrency)
                }
            }
        currencies = []
        downloadData {
            self.localCurrencies = DatabaseManager.shared.getAllFavourites()!
            for local in self.localCurrencies{
                let currencyIndex = self.currencies.index(where: { (currency)  in
                    currency.symbol == local.currencySymbol
                })
                self.currencies[currencyIndex!]._isFavourite = true
//                print("===============")
//                print(self.localCurrencies)
            }
            if self.isSearchActive{
                let searchItem = self.searchBar.text!.lowercased()
                self.filteredCurrencies = self.currencies.filter({$0.name.lowercased().range(of: searchItem) != nil})
            }
            self.tableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
        }
    }
        
    
    
    func currencyTableCellDidTapShare(_ tag: Int) {
        var shareText : String = "Empty String"
        if isSearchActive{
            shareText = "\(filteredCurrencies[tag].name)(\(filteredCurrencies[tag].symbol)) is currently priced at  \(filteredCurrencies[tag].price_usd) USD"
        }
        else{
            shareText = "\(currencies[tag].name)(\(currencies[tag].symbol)) is currently priced at  \(currencies[tag].price_usd) USD"
        }
        
        let activityVC = UIActivityViewController(activityItems: [shareText as Any] , applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        print(shareText)
        self.present(activityVC, animated: true, completion: nil)
    }
    
}

