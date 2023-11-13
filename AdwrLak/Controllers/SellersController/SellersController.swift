//
//  SellersController.swift
//  AdForest
//
//  Created by Apple on 9/6/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift


class SellersController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable,NearBySearchDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,UISearchResultsUpdating {

    //MARK:- Outlets
    @IBOutlet weak var AdpostCirclebtn: UIButton!
        {
        didSet {
                 AdpostCirclebtn.circularButtonShadow()
                 if let bgColor = defaults.string(forKey: "mainColor") {
                     AdpostCirclebtn.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
//                     Shadow and Radius for Circle Button
                           AdpostCirclebtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                           AdpostCirclebtn.layer.masksToBounds = false
                           AdpostCirclebtn.layer.cornerRadius = AdpostCirclebtn.frame.width / 2
                 }
             }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
        }
    }
    
    //MARK:- Properties
    var dataArray = [SellersAuthor]()
    var filteredArray = [SellersAuthor]()
    let defaults = UserDefaults.standard
    var currentPage = 0
    var maximumPage = 0
    
  
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()
    var barButtonItems = [UIBarButtonItem]()
    var searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.bool(forKey: "isRtl") {
            self.addRightBarButtonWithImage()
        } else {
            self.addLeftBarButtonWithImage()
        }
        if defaults.bool(forKey: "isGuest") {
            self.AdpostCirclebtn.isHidden = true
        }
        self.adForest_sellerData()
        self.configureSearchController()

//        navigationButtons()

    }
    
    //Adpost Btn Action/
    @IBAction func actionAdPost(_ sender: UIButton) {
        
        let notVerifyMsg = UserDefaults.standard.string(forKey: "not_Verified")
        let can = UserDefaults.standard.bool(forKey: "can")
        
        if can == false{
            var buttonOk = ""
            var buttonCancel = ""
            if let settingsInfo = defaults.object(forKey: "settings") {
                let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                let model = SettingsRoot(fromDictionary: settingObject)
                
                if let okTitle = model.data.internetDialog.okBtn {
                    buttonOk = okTitle
                }
                if let cancelTitle = model.data.internetDialog.cancelBtn {
                    buttonCancel = cancelTitle
                }
                
                let alertController = UIAlertController(title: "Alert", message: notVerifyMsg, preferredStyle: .alert)
                let okBtn = UIAlertAction(title: buttonOk, style: .default) { (ok) in
                    self.appDelegate.moveToProfile()
                }
                let cancelBtn = UIAlertAction(title: buttonCancel, style: .cancel, handler: nil)
                alertController.addAction(okBtn)
                alertController.addAction(cancelBtn)
                self.presentVC(alertController)
                
            }
        }else{
            let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AadPostController") as! AadPostController
            self.navigationController?.pushViewController(adPostVC, animated: true)
        }
    }

    //MARK:- Custom
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }

    //MARK:- Search Bar delegates
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = ""
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.setValue("Done", forKey: "cancelButtonText")
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filteredArray = dataArray.filter({ (name) -> Bool in
            let nameText: NSString = name.authorName as NSString
            let range = nameText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filteredArray.count == 0 {
            shouldShowSearchResults = false
        } else {
            shouldShowSearchResults = true
        }
        self.tableView.reloadData()
    }
    
    //MARK:- Table View Delegates

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }else{
            return dataArray.count
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SellerCell = tableView.dequeueReusableCell(withIdentifier: "SellerCell", for: indexPath) as! SellerCell
        if shouldShowSearchResults {
            if let name = filteredArray[indexPath.row].authorName {
                cell.lblName.text = name
            }
            if let imgUrl = URL(string: filteredArray[indexPath.row].authorImg) {
                cell.imgProfile.sd_setShowActivityIndicatorView(true)
                cell.imgProfile.sd_setIndicatorStyle(.gray)
                cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            if let location = filteredArray[indexPath.row].authorAddress {
                cell.lblLocation.text = location
            }
            if let rating = filteredArray[indexPath.row].authorRating {
                cell.ratingBar.settings.updateOnTouch = false
                cell.ratingBar.rating = Double(rating)!
                cell.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
            }
            //adding social icons to sellers array
            cell.dataArray = filteredArray[indexPath.row].authorSocial.socialIcons
            cell.collectionView.reloadData()
        }else{
            let objData = dataArray[indexPath.row]
            
            if let imgUrl = URL(string: objData.authorImg) {
                cell.imgProfile.sd_setShowActivityIndicatorView(true)
                cell.imgProfile.sd_setIndicatorStyle(.gray)
                cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name = objData.authorName {
                cell.lblName.text = name
            }
            if let location = objData.authorAddress {
                cell.lblLocation.text = location
            }
            if let rating = objData.authorRating {
                cell.ratingBar.settings.updateOnTouch = false
                cell.ratingBar.rating = Double(rating)!
                cell.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
            }
            //adding social icons to sellers array
            cell.dataArray = objData.authorSocial.socialIcons
            cell.collectionView.reloadData()

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowSearchResults {
            let objData = filteredArray[indexPath.row]
           let publicProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserPublicProfile") as! UserPublicProfile
           publicProfileVC.userID = String(objData.authorId)
           self.navigationController?.pushViewController(publicProfileVC, animated: true)
        }else{
         let objData = dataArray[indexPath.row]
        let publicProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserPublicProfile") as! UserPublicProfile
        publicProfileVC.userID = String(objData.authorId)
        self.navigationController?.pushViewController(publicProfileVC, animated: true)
    }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage  {
            currentPage = currentPage + 1
            let param: [String: Any] = ["page_number": currentPage]
            adForest_loadMoreData(param: param as NSDictionary)
        }
    }

    //MARK:- API Call
    func adForest_sellerData() {
        self.showLoader()
        ShopHandler.sellerList(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray = successResponse.data.authors
                self.tableView.reloadData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adForest_loadMoreData(param: NSDictionary) {
        self.showLoader()
        ShopHandler.sellerListLoadMore(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.dataArray.append(contentsOf: successResponse.data.authors)

                self.tableView.reloadData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //MARK:- Near by search Delaget method
    func nearbySearchParams(lat: Double, long: Double, searchDistance: CGFloat, isSearch: Bool) {
        self.latitude = lat
        self.longitude = long
        self.searchDistance = searchDistance
        if isSearch {
            let param: [String: Any] = ["nearby_latitude": lat, "nearby_longitude": long, "nearby_distance": searchDistance]
            print(param)
            self.adForest_nearBySearch(param: param as NSDictionary)
        } else {
            let param: [String: Any] = ["nearby_latitude": 0.0, "nearby_longitude": 0.0, "nearby_distance": searchDistance]
            print(param)
            self.adForest_nearBySearch(param: param as NSDictionary)
        }
    }
    
    
//    func navigationButtons() {
//
//        //Home Button
//        let HomeButton = UIButton(type: .custom)
//        let ho = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
//        HomeButton.setBackgroundImage(ho, for: .normal)
//        HomeButton.tintColor = UIColor.white
//        HomeButton.setImage(ho, for: .normal)
//        if #available(iOS 11, *) {
//            searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
//            searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        } else {
//            HomeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        }
//        HomeButton.addTarget(self, action: #selector(actionHome), for: .touchUpInside)
//        let homeItem = UIBarButtonItem(customView: HomeButton)
//        if defaults.bool(forKey: "showHome") {
//            barButtonItems.append(homeItem)
//            //self.barButtonItems.append(homeItem)
//        }
//
//        //Location Search
//        let locationButton = UIButton(type: .custom)
//        if #available(iOS 11, *) {
//            locationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//            locationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        }
//        else {
//            locationButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        }
//        let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
//        locationButton.setBackgroundImage(image, for: .normal)
//        locationButton.tintColor = UIColor.white
//        locationButton.addTarget(self, action: #selector(onClicklocationButton), for: .touchUpInside)
//        let barButtonLocation = UIBarButtonItem(customView: locationButton)
//        if defaults.bool(forKey: "showNearBy") {
//            self.barButtonItems.append(barButtonLocation)
//        }
//        //Search Button
//        let searchButton = UIButton(type: .custom)
//        if defaults.bool(forKey: "advanceSearch") == true{
//            let con = UIImage(named: "controls")?.withRenderingMode(.alwaysTemplate)
//            searchButton.setBackgroundImage(con, for: .normal)
//            searchButton.tintColor = UIColor.white
//            searchButton.setImage(con, for: .normal)
//        }else{
//            let con = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
//            searchButton.setBackgroundImage(con, for: .normal)
//            searchButton.tintColor = UIColor.white
//            searchButton.setImage(con, for: .normal)
//        }
//        if #available(iOS 11, *) {
//            searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
//            searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        } else {
//            searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        }
//        searchButton.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
//        let searchItem = UIBarButtonItem(customView: searchButton)
//        if defaults.bool(forKey: "showSearch") {
//            barButtonItems.append(searchItem)
//            //self.barButtonItems.append(searchItem)
//        }
//
//        self.navigationItem.rightBarButtonItems = barButtonItems
//
//    }
    
    @objc func actionHome() {
        appDelegate.moveToHome()
    }
    
    @objc func onClicklocationButton() {
        let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearch") as! LocationSearch
        locationVC.delegate = self
        view.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = .identity
        }) { (success) in
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
    }
    
    
    //MARK:- Search Controller
    
    @objc func actionSearch(_ sender: Any) {
        
        if defaults.bool(forKey: "advanceSearch") == true{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let proVc = storyBoard.instantiateViewController(withIdentifier: "AdvancedSearchController") as! AdvancedSearchController
            self.pushVC(proVc, completion: nil)
        }else{
            
            //setupNavigationBar(title: "okk...")
            
            keyboardManager.enable = true
            if isNavSearchBarShowing {
                navigationItem.titleView = nil
                self.searchBarNavigation.text = ""
                self.backgroundView.removeFromSuperview()
                self.addTitleView()
                
            } else {
                self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.backgroundView.isOpaque = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                tap.delegate = self
                self.backgroundView.addGestureRecognizer(tap)
                self.backgroundView.isUserInteractionEnabled = true
                self.view.addSubview(self.backgroundView)
                self.adNavSearchBar()
            }
        }
        
    }
    
    @objc func handleTap(_ gestureRocognizer: UITapGestureRecognizer) {
        self.actionSearch("")
    }
    
    func adNavSearchBar() {
        searchBarNavigation.placeholder = "Search Ads"
        searchBarNavigation.barStyle = .default
        searchBarNavigation.isTranslucent = false
        searchBarNavigation.barTintColor = UIColor.groupTableViewBackground
        searchBarNavigation.backgroundImage = UIImage()
        searchBarNavigation.sizeToFit()
        searchBarNavigation.delegate = self
        self.isNavSearchBarShowing = true
        searchBarNavigation.isHidden = false
        navigationItem.titleView = searchBarNavigation
        searchBarNavigation.becomeFirstResponder()
    }
    
    func addTitleView() {
        self.searchBarNavigation.endEditing(true)
        self.isNavSearchBarShowing = false
        self.searchBarNavigation.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
    
//    //MARK:- Search Bar Delegates
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        //self.searchBarNavigation.endEditing(true)
//        searchBar.endEditing(true)
//        self.view.endEditing(true)
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.endEditing(true)
//        self.searchBarNavigation.endEditing(true)
//        guard let searchText = searchBar.text else {return}
//        if searchText == "" {
//
//        } else {
//            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
//            categoryVC.searchText = searchText
//            categoryVC.isFromTextSearch = true
//            self.navigationController?.pushViewController(categoryVC, animated: true)
//        }
//    }
    
    
    
    //MARK:- Near By Search
    func adForest_nearBySearch(param: NSDictionary) {
        self.showLoader()
        AddsHandler.nearbyAddsSearch(params: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                categoryVC.latitude = self.latitude
                categoryVC.longitude = self.longitude
                categoryVC.nearByDistance = self.searchDistance
                categoryVC.isFromNearBySearch = true
                self.navigationController?.pushViewController(categoryVC, animated: true)
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    
}
