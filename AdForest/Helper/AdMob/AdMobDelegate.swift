//
//  AdMobDelegate.swift
//  AdForest
//
//  Created by Furqan Nadeem on 08/04/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

import GoogleMobileAds

class AdMobDelegate: NSObject, GADInterstitialDelegate {
    
    var interstitialView: DFPInterstitial!
    //GADInterstitial!
    
    func createAd() -> DFPInterstitial {
        interstitialView = DFPInterstitial(adUnitID: "ca-app-pub-3521346996890484/7679081330")
        interstitialView.delegate = self
        let request = DFPRequest()
//            GADRequest()
        interstitialView.load(request)
        return interstitialView
    }
    
    func showAd() {
        if interstitialView != nil {
            if (interstitialView.isReady == true){
                interstitialView.present(fromRootViewController:currentVc)
            } else {
                print("ad wasn't ready")
                interstitialView = createAd()
            }
        } else {
            print("ad wasn't ready")
            interstitialView = createAd()
        }
    }
    
    func interstitialDidReceiveAd(_ ad: DFPInterstitial) {
        print("Ad Received")
        if ad.isReady {
            interstitialView.present(fromRootViewController: currentVc)
        }
    }
    
    func interstitialDidDismissScreen(_ ad: DFPInterstitial) {
        print("Did Dismiss Screen")
    }
    
    func interstitialWillDismissScreen(_ ad: DFPInterstitial) {
        print("Will Dismiss Screen")
    }
    
    func interstitialWillPresentScreen(_ ad: DFPInterstitial) {
        print("Will present screen")
    }
    
    func interstitialWillLeaveApplication(_ ad: DFPInterstitial) {
        print("Will leave application")
    }
    
    func interstitialDidFail(toPresentScreen ad: DFPInterstitial) {
        print("Failed to present screen")
    }
    
    func interstitial(_ ad: DFPInterstitial, didFailToReceiveAdWithError error: GADRequestError!) {
        print("\(ad) did fail to receive ad with error \(error)")
    }
}
