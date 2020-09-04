//
//  SOTabBarViewController.swift
//  AdForest
//
//  Created by Charlie on 03/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SOTabBar

class SOTabBarViewController: SOTabBarController {
    var defaults = UserDefaults.standard
    var barButtonItems = [UIBarButtonItem]()
    let searchBarNavigation = UISearchBar()

    override func loadView() {
        super.loadView()
        if let bgColor = defaults.string(forKey: "mainColor") {

            SOTabBarSetting.tabBarTintColor = Constants.hexStringToUIColor(hex: bgColor)

            //#colorLiteral(red: 2.248547389e-05, green: 0.7047000527, blue: 0.6947537661, alpha: 1)
            SOTabBarSetting.tabBarCircleSize = CGSize(width: 60, height: 60)
            SOTabBarSetting.tabBarBackground =  UIColor.white


        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addLeftBarButtonWithImage()
        self.navigationButtons()
        self.delegate = self
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarvelHomeViewController")
        let chatStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdvancedSearchController")
        let sleepStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AadPostController")
        let musicStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileController")
        let meStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController")
        
        homeStoryboard.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "blackhome"), selectedImage: UIImage(named: "whitehome"))
        chatStoryboard.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "blacksearch"), selectedImage: UIImage(named: "whitesearch"))
        sleepStoryboard.tabBarItem = UITabBarItem(title: "Sleep", image: UIImage(named: "blackplus"), selectedImage: UIImage(named: "whiteplus"))
        musicStoryboard.tabBarItem = UITabBarItem(title: "Music", image: UIImage(named: "blackuser"), selectedImage: UIImage(named: "whiteuser"))
        meStoryboard.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "blackgear"), selectedImage: UIImage(named: "whitegear"))
        
        viewControllers = [homeStoryboard, chatStoryboard,sleepStoryboard,musicStoryboard,meStoryboard]
        
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func navigationButtons() {
        
        //Home Button
        let HomeButton = UIButton(type: .custom)
        let ho = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        HomeButton.setBackgroundImage(ho, for: .normal)
        HomeButton.tintColor = UIColor.white
        HomeButton.setImage(ho, for: .normal)
        //        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
        //            HomeButton.isHidden = true
        //        }
        if #available(iOS 11, *) {
            searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
            searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            HomeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        //        HomeButton.addTarget(self, action: #selector(actionHome), for: .touchUpInside)
        let homeItem = UIBarButtonItem(customView: HomeButton)
        if defaults.bool(forKey: "showHome") {
            barButtonItems.append(homeItem)
            //self.barButtonItems.append(homeItem)
        }
        
        //        //Location Search
        //        let locationButton = UIButton(type: .custom)
        //        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
        //            locationButton.isHidden = true
        //        }
        //
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
        ////        locationButton.addTarget(self, action: #selector(onClicklocationButton), for: .touchUpInside)
        //        let barButtonLocation = UIBarButtonItem(customView: locationButton)
        //        if defaults.bool(forKey: "showNearBy") {
        //            self.barButtonItems.append(barButtonLocation)
        //        }
        //        //Search Button
        //        let searchButton = UIButton(type: .custom)
        //        //       if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
        //        //           searchButton.isHidden = true
        //        //       }
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
        //
        //        if #available(iOS 11, *) {
        //            searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
        //            searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //        } else {
        //            searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //        }
        ////        searchButton.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
        //        let searchItem = UIBarButtonItem(customView: searchButton)
        //        if defaults.bool(forKey: "showSearch") {
        //            barButtonItems.append(searchItem)
        //            //self.barButtonItems.append(searchItem)
        //        }
        
        self.navigationItem.rightBarButtonItems = barButtonItems
        
    }

}
extension SOTabBarViewController: SOTabBarControllerDelegate {
    func tabBarController(_ tabBarController: SOTabBarController, didSelect viewController: UIViewController) {
        print(viewController.tabBarItem.title ?? "")
    }
}
