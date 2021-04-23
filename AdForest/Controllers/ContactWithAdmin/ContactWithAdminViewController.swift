//
//  ContactWithAdminViewController.swift
//  AdForest
//
//  Created by Charlie on 04/11/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
import MaterialProgressBar
class ContactWithAdminViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    
    
    //MARK:-Properties
    
    
    var  pageUrl = ""
    var  pageTitle = ""
    
    
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        showProgressBar()
        
        let yourBackImage = UIImage(named: "backbutton")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        let url = URL(string: pageUrl)
//        var request = URLRequest(url: url!)
//        request.setValue("body", forHTTPHeaderField: "Adforest-Shop-Request")
//        if UserDefaults.standard.bool(forKey: "isSocial") {
//            request.setValue("social", forHTTPHeaderField: "AdForest-Login-Type")
//        }
        
        guard let userEmail = UserDefaults.standard.string(forKey: "email") else {return}
        guard let userPassword = UserDefaults.standard.string(forKey: "password") else {return}
        guard let shopUrl = defaults.string(forKey: "shopUrl") else {return}
        
        let emailPass = "\(userEmail):\(userPassword)"
        let encodedString = emailPass.data(using: String.Encoding.utf8)!
        let base64String = encodedString.base64EncodedString(options: [])
        print(base64String)
        if url != nil{
            var request = URLRequest(url: url!)
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            request.setValue("body", forHTTPHeaderField: "Adforest-Shop-Request")
            if UserDefaults.standard.bool(forKey: "isSocial") {
                request.setValue("social", forHTTPHeaderField: "AdForest-Login-Type")
            }
          
            request.cachePolicy = .returnCacheDataElseLoad
        
            self.wkWebView.navigationDelegate = self
            self.wkWebView.load(request)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading")
//
//        self.wkWebView.evaluateJavaScript("document.getElementsByClassName(\'sb-light-header\').style.display='none';") { (result, error) in
//            if error == nil {
////                // header is hide now
//            }
//        }
        self.hideProgressBar()

    }

//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            if navigationAction.navigationType == WKNavigationType.linkActivated {
//                print("link")
//
//                decisionHandler(WKNavigationActionPolicy.cancel)
//                return
//            }
//
//            print("no link")
//            decisionHandler(WKNavigationActionPolicy.allow)
//     }

}

